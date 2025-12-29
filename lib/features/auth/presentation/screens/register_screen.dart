import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/datasources/auth_service.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_text_field.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'package:nebula/shared/widgets/phone_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_email_pending_screen.dart';
import 'register_otp_phone_screen.dart';
import 'welcome_screen.dart';

/// Экран регистрации - Шаг 1: Выбор метода (Email или телефон)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pullController;
  late Animation<double> _pullAnimation;
  late Animation<double> _contentScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _blackOverlay;

  bool _isAnimating = false;
  bool _isLoading = false;

  // true = email, false = phone
  bool _isEmailMethod = true;

  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _fullPhoneNumber = '';

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
        _navigateToWelcome();
      }
    });
  }

  void _goBack() {
    if (_isAnimating) return;
    setState(() => _isAnimating = true);
    _pullController.forward();
  }

  void _navigateToWelcome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeScreen(
                playReverseAnimation: true,
                returningFrom: 'register',
              ),
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      );
    });
  }

  Future<void> _continue() async {
    final email = _emailController.text.trim();

    if (_isEmailMethod) {
      if (email.isEmpty) {
        AppNotification.showError(context, 'Введите email');
        return;
      }
      if (!email.contains('@')) {
        AppNotification.showError(context, 'Некорректный email');
        return;
      }

      // Для email — отправляем Email Link
      setState(() => _isLoading = true);

      try {
        // Сохраняем email для последующей верификации
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pendingEmail', email);

        // Отправляем ссылку для входа
        await _authService.sendSignInLinkToEmail(
          email: email,
          continueUrl:
              'https://nebula-messenger-9e1dd.firebaseapp.com/finishSignUp',
        );

        if (mounted) {
          setState(() => _isLoading = false);

          final data = RegistrationData(email: email);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterEmailPendingScreen(data: data),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          AppNotification.showError(context, 'Ошибка: $e');
        }
      }
    } else {
      // Для телефона — отправляем SMS через Firebase
      if (_phoneController.text.isEmpty) {
        AppNotification.showError(context, 'Введите номер телефона');
        return;
      }

      // Используем полный номер с кодом страны
      final formattedPhone = _fullPhoneNumber.isNotEmpty
          ? _fullPhoneNumber
          : '+7${_phoneController.text}';

      setState(() => _isLoading = true);

      try {
        await _authService.verifyPhoneNumber(
          phoneNumber: formattedPhone,
          onCodeSent: (verificationId, resendToken) {
            if (mounted) {
              setState(() => _isLoading = false);

              final data = RegistrationData(
                phone: formattedPhone,
                verificationId: verificationId,
                resendToken: resendToken,
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RegisterOtpPhoneScreen(data: data),
                ),
              );
            }
          },
          onVerificationCompleted: (credential) {
            // Автоматическая верификация (на Android)
            // Можно использовать для автоматического входа
          },
          onVerificationFailed: (e) {
            if (mounted) {
              setState(() => _isLoading = false);
              AppNotification.showError(
                context,
                'Ошибка отправки SMS: ${e.message ?? e.code}',
              );
            }
          },
          onCodeAutoRetrievalTimeout: (verificationId) {
            // Таймаут автозаполнения — ничего не делаем
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          AppNotification.showError(context, 'Ошибка: ${e.toString()}');
        }
      }
    }
  }

  @override
  void dispose() {
    _pullController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pullController,
        builder: (context, child) {
          return Stack(
            children: [
              NebulaBackground(
                pullStrength: _pullAnimation.value,
                child: SafeArea(
                  child: Transform.scale(
                    scale: _contentScale.value,
                    child: Opacity(
                      opacity: _contentOpacity.value,
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
                                    const NebulaLogo(
                                      logoSize: 60,
                                      fontSize: 23,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Регистрация',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Шаг 1 из 5',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Переключатель метода
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => setState(
                                                () => _isEmailMethod = true,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _isEmailMethod
                                                      ? Colors.white
                                                            .withOpacity(0.2)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.email_outlined,
                                                      color: _isEmailMethod
                                                          ? Colors.white
                                                          : Colors.white
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Email',
                                                      style: TextStyle(
                                                        color: _isEmailMethod
                                                            ? Colors.white
                                                            : Colors.white
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                        fontWeight:
                                                            _isEmailMethod
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => setState(
                                                () => _isEmailMethod = false,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: !_isEmailMethod
                                                      ? Colors.white
                                                            .withOpacity(0.2)
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.phone_outlined,
                                                      color: !_isEmailMethod
                                                          ? Colors.white
                                                          : Colors.white
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Телефон',
                                                      style: TextStyle(
                                                        color: !_isEmailMethod
                                                            ? Colors.white
                                                            : Colors.white
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                        fontWeight:
                                                            !_isEmailMethod
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Поле ввода (Email или Phone)
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: _isEmailMethod
                                          ? GlassTextField(
                                              key: const ValueKey('email'),
                                              controller: _emailController,
                                              hintText: 'Email',
                                              prefixIcon: Icons.email_outlined,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            )
                                          : PhoneInputField(
                                              key: const ValueKey('phone'),
                                              controller: _phoneController,
                                              hintText: 'Номер телефона',
                                              onFullPhoneChanged: (phone) {
                                                _fullPhoneNumber = phone;
                                              },
                                            ),
                                    ),
                                    const SizedBox(height: 24),
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
                                              text: 'Продолжить',
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                                size: 20,
                                              ),
                                              onPressed: _continue,
                                            ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Back button
                                    TextButton.icon(
                                      onPressed: _isAnimating ? null : _goBack,
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white.withOpacity(0.6),
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Back to Welcome',
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
