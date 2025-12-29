import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/datasources/user_service.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/features/auth/data/models/user_model.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';

/// Шаг 5: Установка аватарки
class RegisterAvatarScreen extends StatefulWidget {
  final RegistrationData data;

  const RegisterAvatarScreen({super.key, required this.data});

  @override
  State<RegisterAvatarScreen> createState() => _RegisterAvatarScreenState();
}

class _RegisterAvatarScreenState extends State<RegisterAvatarScreen> {
  bool _isLoading = false;
  String? _avatarUrl;

  final _userService = UserService();

  Future<void> _pickAvatar() async {
    // TODO: Реализовать выбор изображения и загрузку в Firebase Storage
    AppNotification.showInfo(context, 'Выбор аватарки будет доступен позже');
  }

  Future<void> _finishRegistration({bool skipAvatar = false}) async {
    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        AppNotification.showError(context, 'Ошибка авторизации');
        return;
      }

      // Создаём профиль в Firestore
      final user = UserModel(
        uid: currentUser.uid,
        email: widget.data.email,
        firstName: widget.data.firstName,
        lastName: widget.data.lastName,
        username: widget.data.email.split('@').first, // Временный username
        phone: widget.data.phone,
        createdAt: DateTime.now(),
        photoUrl: skipAvatar ? null : _avatarUrl,
      );

      await _userService.createUserProfile(user);

      if (mounted) {
        AppNotification.showSuccess(context, 'Регистрация завершена!');
        // TODO: Навигация на главный экран
        // Пока просто очищаем стек навигации
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      AppNotification.showError(context, 'Ошибка: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NebulaBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassContainer(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const NebulaLogo(logoSize: 60, fontSize: 23),
                        const SizedBox(height: 8),
                        Text(
                          'Фото профиля',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Шаг 5 из 5',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Аватар
                        GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: _avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _avatarUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 40,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Нажмите чтобы выбрать фото',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Кнопка продолжить
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : NebulaGlassButton(
                                  text: 'Завершить',
                                  icon: const Icon(Icons.check, size: 20),
                                  onPressed: () =>
                                      _finishRegistration(skipAvatar: false),
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Пропустить
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => _finishRegistration(skipAvatar: true),
                          child: Text(
                            'Пропустить',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Back button
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white.withOpacity(0.6),
                            size: 18,
                          ),
                          label: Text(
                            'Назад',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
