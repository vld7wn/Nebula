import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель пользователя
class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final DateTime createdAt;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phone,
    required this.createdAt,
    this.photoUrl,
  });

  /// Создать из Firestore документа
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      username: data['username'] ?? '',
      phone: data['phone'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      photoUrl: data['photoUrl'],
    );
  }

  /// Конвертировать в Map для Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'photoUrl': photoUrl,
    };
  }

  /// Полное имя
  String get fullName => '$firstName $lastName'.trim();
}
