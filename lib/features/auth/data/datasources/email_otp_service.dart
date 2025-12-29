import 'package:cloud_functions/cloud_functions.dart';

/// Сервис для Email OTP верификации через Cloud Functions
class EmailOtpService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Отправить OTP код на email
  /// Возвращает true если код отправлен успешно
  Future<bool> sendOtp(String email) async {
    try {
      final callable = _functions.httpsCallable('sendEmailOtp');
      final result = await callable.call({'email': email});

      return result.data['success'] == true;
    } on FirebaseFunctionsException catch (e) {
      throw EmailOtpException(
        code: e.code,
        message: e.message ?? 'Ошибка отправки кода',
      );
    } catch (e) {
      throw EmailOtpException(
        code: 'unknown',
        message: 'Неизвестная ошибка: $e',
      );
    }
  }

  /// Проверить OTP код
  /// Возвращает true если код верный
  Future<bool> verifyOtp(String email, String code) async {
    try {
      final callable = _functions.httpsCallable('verifyEmailOtp');
      final result = await callable.call({'email': email, 'code': code});

      return result.data['verified'] == true;
    } on FirebaseFunctionsException catch (e) {
      throw EmailOtpException(
        code: e.code,
        message: e.message ?? 'Ошибка проверки кода',
      );
    } catch (e) {
      throw EmailOtpException(
        code: 'unknown',
        message: 'Неизвестная ошибка: $e',
      );
    }
  }
}

/// Исключение для ошибок Email OTP
class EmailOtpException implements Exception {
  final String code;
  final String message;

  EmailOtpException({required this.code, required this.message});

  @override
  String toString() => message;
}
