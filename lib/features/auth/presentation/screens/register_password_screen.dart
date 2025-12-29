import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/datasources/auth_service.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_password_field.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'register_name_screen.dart';

/// Шаг 3: Установка пароля
class RegisterPasswordScreen extends StatefulWidget {
  final RegistrationData data;

  const RegisterPasswordScreen({super.key, required this.data});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  bool _isLoading = false;

  final _authService = AuthService();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _createAccount() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      AppNotification.showError(context, 'Введите пароль');
      return;
    }

    if (password.length < 6) {
      AppNotification.showError(context, 'Пароль минимум 6 символов');
      return;
    }

    if (password != confirmPassword) {
      AppNotification.showError(context, 'Пароли не совпадают');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Создаём аккаунт в Firebase Auth
      await _authService.signUpWithEmail(
        email: widget.data.email,
        password: password,
      );

      // Сохраняем пароль в данных
      widget.data.password = password;

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterNameScreen(data: widget.data),
          ),
        );
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
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                        const NebulaLogo(logoSize: 80, fontSize: 28),
                        const SizedBox(height: 8),
                        Text(
                          'Создание пароля',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Шаг 3 из 5',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Пароль
                        GlassPasswordField(
                          controller: _passwordController,
                          hintText: 'Пароль',
                        ),
                        const SizedBox(height: 16),
                        // Подтверждение
                        GlassPasswordField(
                          controller: _confirmPasswordController,
                          hintText: 'Подтвердите пароль',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Минимум 6 символов',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Кнопка
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : NebulaGlassButton(
                                  text: 'Продолжить',
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                  ),
                                  onPressed: _createAccount,
                                ),
                        ),
                        const SizedBox(height: 16),
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
