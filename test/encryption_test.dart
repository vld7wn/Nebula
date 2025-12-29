import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nebula/data/services/encryption_service.dart';

void main() {
  late NebulaEncryptionService service;

  setUp(() {
    service = NebulaEncryptionService();
  });

  group('EncryptionMethod recommendation', () {
    test('recommends AES-GCM for small data', () {
      expect(
        service.recommendMethod(1024), // 1 KB
        equals(EncryptionMethod.aesGcm),
      );
    });

    test('recommends XChaCha20 for large files', () {
      expect(
        service.recommendMethod(2 * 1024 * 1024), // 2 MB
        equals(EncryptionMethod.xchacha20),
      );
    });

    test('recommends ChaCha20 for mobile preference', () {
      expect(
        service.recommendMethod(1024, preferMobile: true),
        equals(EncryptionMethod.chacha20),
      );
    });
  });

  group('AES-256-GCM', () {
    test('encrypt and decrypt string', () async {
      final key = await service.generateKey(EncryptionMethod.aesGcm);
      const plaintext = 'Hello, Nebula! 🚀';

      final encrypted = await service.encryptString(
        plaintext,
        key,
        method: EncryptionMethod.aesGcm,
      );
      final decrypted = await service.decryptString(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('encrypt and decrypt bytes', () async {
      final key = await service.generateKey(EncryptionMethod.aesGcm);
      final plaintext = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final encrypted = await service.encrypt(
        plaintext,
        key,
        method: EncryptionMethod.aesGcm,
      );
      final decrypted = await service.decrypt(encrypted, key);

      expect(decrypted, equals(plaintext));
      expect(encrypted.method, equals(EncryptionMethod.aesGcm));
    });
  });

  group('ChaCha20-Poly1305', () {
    test('encrypt and decrypt string', () async {
      final key = await service.generateKey(EncryptionMethod.chacha20);
      const plaintext = 'Mobile encryption test! 📱';

      final encrypted = await service.encryptString(
        plaintext,
        key,
        method: EncryptionMethod.chacha20,
      );
      final decrypted = await service.decryptString(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('encrypt and decrypt bytes', () async {
      final key = await service.generateKey(EncryptionMethod.chacha20);
      final plaintext = Uint8List.fromList(List.generate(256, (i) => i));

      final encrypted = await service.encrypt(
        plaintext,
        key,
        method: EncryptionMethod.chacha20,
      );
      final decrypted = await service.decrypt(encrypted, key);

      expect(decrypted, equals(plaintext));
      expect(encrypted.method, equals(EncryptionMethod.chacha20));
    });
  });

  group('XChaCha20-Poly1305', () {
    test('encrypt and decrypt string', () async {
      final key = await service.generateKey(EncryptionMethod.xchacha20);
      const plaintext = 'Large file encryption! 📁';

      final encrypted = await service.encryptString(
        plaintext,
        key,
        method: EncryptionMethod.xchacha20,
      );
      final decrypted = await service.decryptString(encrypted, key);

      expect(decrypted, equals(plaintext));
    });

    test('encrypt and decrypt bytes', () async {
      final key = await service.generateKey(EncryptionMethod.xchacha20);
      final plaintext = Uint8List.fromList(List.generate(1024, (i) => i % 256));

      final encrypted = await service.encrypt(
        plaintext,
        key,
        method: EncryptionMethod.xchacha20,
      );
      final decrypted = await service.decrypt(encrypted, key);

      expect(decrypted, equals(plaintext));
      expect(encrypted.method, equals(EncryptionMethod.xchacha20));
      // XChaCha20 uses 24-byte nonce (192-bit)
      expect(encrypted.nonce.length, equals(24));
    });
  });

  group('EncryptedData serialization', () {
    test('base64 round-trip for AES-GCM', () async {
      final key = await service.generateKey(EncryptionMethod.aesGcm);
      final plaintext = Uint8List.fromList([10, 20, 30, 40]);

      final encrypted = await service.encrypt(
        plaintext,
        key,
        method: EncryptionMethod.aesGcm,
      );

      final base64 = encrypted.toBase64();
      final restored = EncryptedData.fromBase64(base64);

      expect(restored.method, equals(encrypted.method));
      expect(restored.nonce, equals(encrypted.nonce));
      expect(restored.mac, equals(encrypted.mac));
      expect(restored.ciphertext, equals(encrypted.ciphertext));
    });

    test('base64 round-trip for XChaCha20', () async {
      final key = await service.generateKey(EncryptionMethod.xchacha20);
      final plaintext = Uint8List.fromList([100, 200, 150]);

      final encrypted = await service.encrypt(
        plaintext,
        key,
        method: EncryptionMethod.xchacha20,
      );

      final base64 = encrypted.toBase64();
      final restored = EncryptedData.fromBase64(base64);

      expect(restored.method, equals(EncryptionMethod.xchacha20));
      expect(restored.nonce.length, equals(24)); // 192-bit nonce
    });
  });

  group('Cross-method isolation', () {
    test('different keys produce different ciphertext', () async {
      final key1 = await service.generateKey(EncryptionMethod.aesGcm);
      final key2 = await service.generateKey(EncryptionMethod.aesGcm);
      final plaintext = Uint8List.fromList([1, 2, 3]);

      final encrypted1 = await service.encrypt(plaintext, key1);
      final encrypted2 = await service.encrypt(plaintext, key2);

      expect(encrypted1.ciphertext, isNot(equals(encrypted2.ciphertext)));
    });

    test('wrong key fails decryption', () async {
      final key1 = await service.generateKey(EncryptionMethod.aesGcm);
      final key2 = await service.generateKey(EncryptionMethod.aesGcm);
      final plaintext = Uint8List.fromList([1, 2, 3]);

      final encrypted = await service.encrypt(plaintext, key1);

      expect(() => service.decrypt(encrypted, key2), throwsA(anything));
    });
  });

  group('Legacy EncryptionService compatibility', () {
    test('encrypt and decrypt string', () async {
      final legacy = EncryptionService();
      const plaintext = 'Legacy compatibility test';

      final encrypted = await legacy.encrypt(plaintext);
      final decrypted = await legacy.decrypt(encrypted);

      expect(decrypted, equals(plaintext));
    });
  });
}
