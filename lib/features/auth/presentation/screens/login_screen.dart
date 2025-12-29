import 'package:flutter/material.dart';
import 'package:nebula/features/auth/data/datasources/auth_service.dart';
import 'package:nebula/features/auth/data/datasources/user_service.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_password_field.dart';
import 'package:nebula/shared/widgets/glass_text_field.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'welcome_screen.dart';

/// Экран авторизации
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pullController;
  late Animation<double> _pullAnimation;
  late Animation<double> _contentScale;
  late Animation<double> _contentOpacity;
  late Animation<double> _blackOverlay;

  bool _isAnimating = false;
  bool _isLoading = false;

  final _authService = AuthService();
  final _userService = UserService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

    setState(() {
      _isAnimating = true;
    });

    _pullController.forward();
  }

  Future<void> _signIn() async {
    final input = _emailController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      _showError('Заполните все поля');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Преобразуем логин/телефон в email
      final email = await _userService.resolveEmailFromInput(input);

      // Проверяем, нашли ли пользователя (если введён не email)
      if (!input.contains('@') && email == input) {
        _showError('Пользователь не найден');
        setState(() => _isLoading = false);
        return;
      }

      await _authService.signInWithEmail(email: email, password: password);
      if (mounted) {
        // TODO: Навигация на главный экран
        _showSuccess('Вход выполнен!');
      }
    } catch (e) {
      _showError('Ошибка входа: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    AppNotification.showError(context, message);
  }

  void _showSuccess(String message) {
    AppNotification.showSuccess(context, message);
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        _showSuccess('Вход через Google выполнен!');
      }
    } catch (e) {
      _showError('Ошибка входа через Google: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithApple();
      if (mounted) {
        _showSuccess('Вход через Apple выполнен!');
      }
    } catch (e) {
      _showError('Ошибка входа через Apple: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToWelcome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeScreen(
                playReverseAnimation: true,
                returningFrom: 'login',
              ),
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _pullController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Glassmorphism рамка
                              GlassContainer(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Логотип (горизонтальный, компактный)
                                    const NebulaLogo(
                                      logoSize: 80,
                                      fontSize: 28,
                                    ),
                                    const SizedBox(height: 32),
                                    // Поле email/логин
                                    GlassTextField(
                                      controller: _emailController,
                                      hintText:
                                          'Email / Логин / Номер телефона',
                                      prefixIcon: Icons.person_outline,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 16),
                                    // Поле пароль
                                    GlassPasswordField(
                                      controller: _passwordController,
                                      hintText: 'Пароль',
                                    ),
                                    const SizedBox(height: 12),
                                    // Forgot Password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // TODO: Навигация на восстановление пароля
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Sign In Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: _isLoading
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : NebulaGlassButton(
                                              text: 'Sign In',
                                              icon: const Icon(
                                                Icons.login,
                                                size: 20,
                                              ),
                                              onPressed: _signIn,
                                            ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Разделитель
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            'или',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    // Google Sign In
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _signInWithGoogle,
                                        icon: Image.asset(
                                          'assets/images/icons/google.png',
                                          width: 24,
                                          height: 24,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
                                                Icons.g_mobiledata,
                                                size: 24,
                                              ),
                                        ),
                                        label: const Text('Войти через Google'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Apple Sign In
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _signInWithApple,
                                        icon: const Icon(Icons.apple, size: 24),
                                        label: const Text('Войти через Apple'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
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

              // Чёрный overlay
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
