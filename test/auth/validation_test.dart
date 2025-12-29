import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Field Validation', () {
    group('Email Validation', () {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      test('accepts valid emails', () {
        expect(emailRegex.hasMatch('user@example.com'), true);
        expect(emailRegex.hasMatch('user.name@example.com'), true);
        expect(emailRegex.hasMatch('user@sub.example.com'), true);
        expect(emailRegex.hasMatch('user123@example.co'), true);
      });

      test('rejects invalid emails', () {
        expect(emailRegex.hasMatch(''), false);
        expect(emailRegex.hasMatch('user'), false);
        expect(emailRegex.hasMatch('user@'), false);
        expect(emailRegex.hasMatch('@example.com'), false);
        expect(emailRegex.hasMatch('user @example.com'), false);
      });
    });

    group('Password Validation', () {
      bool isStrongPassword(String password) {
        if (password.length < 8) return false;
        if (!password.contains(RegExp(r'[A-Z]'))) return false;
        if (!password.contains(RegExp(r'[a-z]'))) return false;
        if (!password.contains(RegExp(r'[0-9]'))) return false;
        return true;
      }

      test('accepts strong passwords', () {
        expect(isStrongPassword('Password1'), true);
        expect(isStrongPassword('MyPass123'), true);
        expect(isStrongPassword('Secure@1234'), true);
      });

      test('rejects weak passwords', () {
        expect(isStrongPassword('pass'), false); // too short
        expect(isStrongPassword('password'), false); // no uppercase, no digit
        expect(isStrongPassword('PASSWORD1'), false); // no lowercase
        expect(isStrongPassword('Password'), false); // no digit
      });
    });

    group('Username Validation', () {
      bool isValidUsername(String username) {
        if (username.length < 3 || username.length > 20) return false;
        return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
      }

      test('accepts valid usernames', () {
        expect(isValidUsername('user'), true);
        expect(isValidUsername('user123'), true);
        expect(isValidUsername('user_name'), true);
        expect(isValidUsername('User_Name_123'), true);
      });

      test('rejects invalid usernames', () {
        expect(isValidUsername('ab'), false); // too short
        expect(isValidUsername('a' * 21), false); // too long
        expect(isValidUsername('user-name'), false); // invalid char
        expect(isValidUsername('user name'), false); // space
        expect(isValidUsername('user@name'), false); // special char
      });
    });

    group('Phone Validation', () {
      bool isValidPhone(String phone) {
        final digits = phone.replaceAll(RegExp(r'\D'), '');
        return digits.length >= 10 && digits.length <= 15;
      }

      test('accepts valid phone numbers', () {
        expect(isValidPhone('+7 999 888 77 66'), true);
        expect(isValidPhone('79998887766'), true);
        expect(isValidPhone('+1-555-123-4567'), true);
        expect(isValidPhone('(555) 123-4567'), true);
      });

      test('rejects invalid phone numbers', () {
        expect(isValidPhone('123'), false); // too short
        expect(isValidPhone(''), false);
      });
    });
  });
}
