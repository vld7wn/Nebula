import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nebula/features/auth/data/models/user_model.dart';

/// Сервис для работы с профилями пользователей в Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Коллекция пользователей
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  /// Создать профиль пользователя
  Future<void> createUserProfile(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toFirestore());
  }

  /// Получить профиль пользователя по uid
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Обновить профиль пользователя
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  /// Проверить доступность username
  Future<bool> isUsernameAvailable(String username) async {
    final query = await _usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  /// Проверить доступность телефона
  Future<bool> isPhoneAvailable(String phone) async {
    final query = await _usersCollection
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    return query.docs.isEmpty;
  }

  /// Поток данных пользователя (realtime)
  Stream<UserModel?> userStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Найти email по логину
  Future<String?> findEmailByUsername(String username) async {
    final query = await _usersCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.data()['email'] as String?;
  }

  /// Найти email по телефону
  Future<String?> findEmailByPhone(String phone) async {
    final query = await _usersCollection
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.data()['email'] as String?;
  }

  /// Найти email по логину, телефону или вернуть как есть (если это email)
  Future<String> resolveEmailFromInput(String input) async {
    // Если это email — вернуть как есть
    if (input.contains('@')) {
      return input;
    }

    // Если начинается с + или содержит только цифры — это телефон
    if (input.startsWith('+') || RegExp(r'^\d+$').hasMatch(input)) {
      final email = await findEmailByPhone(input);
      if (email != null) return email;
    }

    // Иначе — это username
    final email = await findEmailByUsername(input);
    if (email != null) return email;

    // Если ничего не найдено — вернуть как есть (Firebase даст ошибку)
    return input;
  }
}
