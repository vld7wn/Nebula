import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Сервис авторизации через Firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Текущий пользователь
  User? get currentUser => _auth.currentUser;

  /// Поток состояния авторизации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Вход по email и паролю
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Регистрация по email и паролю
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Вход через Google
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // Пользователь отменил

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  /// Вход через Apple
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');

    return await _auth.signInWithProvider(appleProvider);
  }

  /// Сброс пароля
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Верификация номера телефона
  /// Отправляет SMS с кодом подтверждения
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    required void Function(String verificationId) onCodeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  /// Проверка OTP кода телефона
  /// Возвращает credential для дальнейшего использования
  PhoneAuthCredential getPhoneCredential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  /// Привязка телефона к существующему аккаунту
  Future<UserCredential> linkPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'Пользователь не авторизован',
      );
    }
    return await user.linkWithCredential(credential);
  }

  /// Вход через телефон
  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    return await _auth.signInWithCredential(credential);
  }

  // ==================== EMAIL LINK AUTHENTICATION ====================

  /// Отправка ссылки для входа на email
  /// Пользователь получит письмо со ссылкой для авторизации
  Future<void> sendSignInLinkToEmail({
    required String email,
    required String continueUrl,
    bool handleCodeInApp = true,
    String? androidPackageName,
    String? iOSBundleId,
  }) async {
    final actionCodeSettings = ActionCodeSettings(
      url: continueUrl,
      handleCodeInApp: handleCodeInApp,
      androidPackageName: androidPackageName ?? 'com.mikhail.nebula',
      androidInstallApp: true,
      androidMinimumVersion: '21',
      iOSBundleId: iOSBundleId ?? 'com.mikhail.nebula',
    );

    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
  }

  /// Проверка, является ли ссылка Email Link
  bool isSignInWithEmailLink(String emailLink) {
    return _auth.isSignInWithEmailLink(emailLink);
  }

  /// Вход по email ссылке
  Future<UserCredential> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    return await _auth.signInWithEmailLink(email: email, emailLink: emailLink);
  }

  /// Выход
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
