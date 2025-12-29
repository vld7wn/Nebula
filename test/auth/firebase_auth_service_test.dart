import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirebaseAuthService', () {
    group('Email Validation', () {
      test('valid email format', () {
        expect(
          RegExp(
            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
          ).hasMatch('test@email.com'),
          true,
        );
      });

      test('invalid email without @', () {
        expect(
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch('testemail.com'),
          false,
        );
      });

      test('invalid email without domain', () {
        expect(
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch('test@'),
          false,
        );
      });
    });

    group('Password Validation', () {
      bool isValidPassword(String password) {
        return password.length >= 6;
      }

      test('valid password (6+ chars)', () {
        expect(isValidPassword('password123'), true);
      });

      test('invalid password (too short)', () {
        expect(isValidPassword('12345'), false);
      });

      test('empty password is invalid', () {
        expect(isValidPassword(''), false);
      });
    });

    group('Phone Validation', () {
      bool isValidPhone(String phone) {
        return RegExp(r'^\+?[1-9]\d{9,14}$').hasMatch(phone);
      }

      test('valid phone with +', () {
        expect(isValidPhone('+79998887766'), true);
      });

      test('valid phone without +', () {
        expect(isValidPhone('79998887766'), true);
      });

      test('invalid phone (too short)', () {
        expect(isValidPhone('+7999'), false);
      });
    });
  });
}
