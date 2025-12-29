import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/datasources/auth_service.dart';
import 'package:nebula/features/auth/presentation/screens/login_screen.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_text_field.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';

/// Экран сброса пароля
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pullController;
  late Animation<double> _pullAnimation;
  late Animation<double> _contentScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _blackOverlay;

  bool _isAnimating = false;
  bool _isLoading = false;
  bool _emailSent = false;

  final _authService = AuthService();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _pullController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pullAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pullController, curve: Curves.easeInQuart),
    );

    _contentScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInBack),
      ),
    );
    _contentOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _blackOverlay = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _pullController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pullController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    _pullController.forward();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      AppNotification.showError(context, 'Введите email');
      return;
    }

    if (!email.contains('@')) {
      AppNotification.showError(context, 'Некорректный email');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(email);

      if (mounted) {
        setState(() {
          _emailSent = true;
          _isLoading = false;
        });

        AppNotification.showSuccess(
          context,
          'Письмо для сброса пароля отправлено на $email',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppNotification.showError(context, 'Ошибка: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pullController,
        builder: (context, child) {
          return Stack(
            children: [
              // Фон с чёрной дырой
              NebulaBackground(
                pullStrength: _pullAnimation.value,
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Transform.scale(
                        scale: _contentScale.value,
                        child: Opacity(
                          opacity: _contentOpacity.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GlassContainer(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Логотип
                                    const NebulaLogo(
                                      logoSize: 60,
                                      fontSize: 23,
                                    ),
                                    const SizedBox(height: 24),

                                    // Заголовок
                                    Text(
                                      _emailSent
                                          ? 'Письмо отправлено!'
                                          : 'Сброс пароля',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Описание
                                    Text(
                                      _emailSent
                                          ? 'Проверьте почту и перейдите по ссылке для сброса пароля.'
                                          : 'Введите email, привязанный к аккаунту. Мы отправим ссылку для сброса пароля.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 32),

                                    if (!_emailSent) ...[
                                      // Поле email
                                      GlassTextField(
                                        controller: _emailController,
                                        hintText: 'Email',
                                        prefixIcon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      const SizedBox(height: 24),

                                      // Кнопка отправки
                                      NebulaGlassButton(
                                        text: 'Отправить',
                                        onPressed: _resetPassword,
                                        isLoading: _isLoading,
                                      ),
                                    ] else ...[
                                      // Иконка успеха
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green.withOpacity(0.2),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(
                                              0.5,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.mark_email_read_outlined,
                                          color: Colors.green,
                                          size: 48,
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Кнопка повторной отправки
                                      TextButton(
                                        onPressed: () {
                                          setState(() => _emailSent = false);
                                        },
                                        child: Text(
                                          'Отправить повторно',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 16),

                                    // Кнопка назад
                                    TextButton.icon(
                                      onPressed: _goBack,
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Back to Sign In',
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
                ),
              ),

              // Чёрный оверлей для перехода
              if (_blackOverlay.value > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withOpacity(_blackOverlay.value),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
