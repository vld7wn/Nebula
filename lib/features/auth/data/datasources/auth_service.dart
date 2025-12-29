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

  /// Выход
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
