import 'package:flutter/material.dart';
import 'package:nebula/core/services/otp_code_generator.dart';
import 'package:nebula/shared/widgets/animated_code_display.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// Экран приветствия с анимацией засасывания в чёрную дыру
class WelcomeScreen extends StatefulWidget {
  final bool playReverseAnimation;
  final String? returningFrom;

  const WelcomeScreen({
    super.key,
    this.playReverseAnimation = false,
    this.returningFrom,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pullController;
  late AnimationController _appearController;

  // Генератор одноразового кода
  late OtpCodeGenerator _otpGenerator;

  // Анимации засасывания (FORWARD)
  late Animation<double> _pullAnimation;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _otherButtonScale;
  late Animation<double> _otherButtonOpacity;
  late Animation<double> _clickedButtonScale;
  late Animation<double> _clickedButtonOpacity;
  late Animation<double> _blackOverlay;

  // Анимации появления (REVERSE) — отдельно настроенные
  late Animation<double> _appearBlackOverlay;
  late Animation<double> _appearLogoScale;
  late Animation<double> _appearLogoOpacity;
  late Animation<double> _appearOtherButtonScale;
  late Animation<double> _appearOtherButtonOpacity;
  late Animation<double> _appearClickedButtonScale;
  late Animation<double> _appearClickedButtonOpacity;

  bool _isAnimating = false;
  bool _isAppearing = false;
  String? _targetScreen;

  @override
  void initState() {
    super.initState();

    // Инициализируем генератор кода
    _otpGenerator = OtpCodeGenerator();

    // Подписываемся на lifecycle события
    WidgetsBinding.instance.addObserver(this);

    // Контроллер для засасывания
    _pullController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Контроллер для появления
    _appearController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _setupPullAnimations();
    _setupAppearAnimations();

    _pullController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTarget();
      }
    });

    _appearController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAppearing = false;
          _isAnimating = false;
          _targetScreen = null;
        });
      }
    });

    // Если нужно появление из темноты
    if (widget.playReverseAnimation) {
      _isAppearing = true;
      _isAnimating = true;
      _targetScreen = widget.returningFrom;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _appearController.forward();
        }
      });
    }
  }

  void _setupPullAnimations() {
    _pullAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pullController, curve: Curves.easeInQuart),
    );

    // Порядок: лого → другая кнопка → нажатая кнопка → чёрный экран
    _logoScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeInBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _otherButtonScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.25, 0.55, curve: Curves.easeInBack),
      ),
    );
    _otherButtonOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.25, 0.5, curve: Curves.easeIn),
      ),
    );

    _clickedButtonScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeInBack),
      ),
    );
    _clickedButtonOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
      ),
    );

    _blackOverlay = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pullController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _setupAppearAnimations() {
    // Порядок появления: чёрный экран исчезает → лого → другая кнопка → нажатая кнопка
    _appearBlackOverlay = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _appearLogoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOutBack),
      ),
    );
    _appearLogoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.1, 0.35, curve: Curves.easeOut),
      ),
    );

    _appearOtherButtonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutBack),
      ),
    );
    _appearOtherButtonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.4, 0.65, curve: Curves.easeOut),
      ),
    );

    _appearClickedButtonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOutBack),
      ),
    );
    _appearClickedButtonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appearController,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );
  }

  void _startPullAnimation(String target) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _targetScreen = target;
    });

    _pullController.forward();
  }

  void _navigateToTarget() {
    final targetWidget = _targetScreen == 'login'
        ? const LoginScreen()
        : const RegisterScreen();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => targetWidget,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // При сворачивании приложения — генерируем новый код
    if (state == AppLifecycleState.paused) {
      _otpGenerator.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      _otpGenerator.onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _otpGenerator.dispose();
    _pullController.dispose();
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final topPadding = screenHeight * 0.25;
    final logoSize = screenWidth < 400 ? 100.0 : 150.0;
    final fontSize = screenWidth < 400 ? 36.0 : 46.0;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_pullController, _appearController]),
        builder: (context, child) {
          // Определяем какие значения использовать
          double logoScaleVal, logoOpacityVal;
          double otherBtnScaleVal, otherBtnOpacityVal;
          double clickedBtnScaleVal, clickedBtnOpacityVal;
          double overlayVal;
          double pullStrength;

          if (_isAppearing) {
            // Анимация появления
            logoScaleVal = _appearLogoScale.value;
            logoOpacityVal = _appearLogoOpacity.value;
            otherBtnScaleVal = _appearOtherButtonScale.value;
            otherBtnOpacityVal = _appearOtherButtonOpacity.value;
            clickedBtnScaleVal = _appearClickedButtonScale.value;
            clickedBtnOpacityVal = _appearClickedButtonOpacity.value;
            overlayVal = _appearBlackOverlay.value;
            pullStrength = 0.0; // Не ускоряем дыру при появлении
          } else {
            // Анимация засасывания
            logoScaleVal = _logoScale.value;
            logoOpacityVal = _logoOpacity.value;
            otherBtnScaleVal = _otherButtonScale.value;
            otherBtnOpacityVal = _otherButtonOpacity.value;
            clickedBtnScaleVal = _clickedButtonScale.value;
            clickedBtnOpacityVal = _clickedButtonOpacity.value;
            overlayVal = _blackOverlay.value;
            pullStrength = _pullAnimation.value;
          }

          return Stack(
            children: [
              NebulaBackground(
                pullStrength: pullStrength,
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: topPadding),

                      // Лого + текст
                      Transform.scale(
                        scale: logoScaleVal.clamp(0.0, 1.0),
                        child: Opacity(
                          opacity: logoOpacityVal.clamp(0.0, 1.0),
                          child: NebulaLogo(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Одноразовый код для регистрации
                      Transform.scale(
                        scale: logoScaleVal.clamp(0.0, 1.0),
                        child: Opacity(
                          opacity: logoOpacityVal.clamp(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: AnimatedCodeDisplay(
                              generator: _otpGenerator,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight < 700 ? 80 : 150),

                      // Кнопки
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildButton(
                                text: 'Sign In',
                                icon: const Icon(Icons.login, size: 20),
                                isClicked: _targetScreen == 'login',
                                scale: _targetScreen == 'login'
                                    ? clickedBtnScaleVal
                                    : otherBtnScaleVal,
                                opacity: _targetScreen == 'login'
                                    ? clickedBtnOpacityVal
                                    : otherBtnOpacityVal,
                                onPressed: () => _startPullAnimation('login'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildButton(
                                text: 'Register',
                                icon: const Icon(Icons.person_add, size: 20),
                                isClicked: _targetScreen == 'register',
                                scale: _targetScreen == 'register'
                                    ? clickedBtnScaleVal
                                    : otherBtnScaleVal,
                                opacity: _targetScreen == 'register'
                                    ? clickedBtnOpacityVal
                                    : otherBtnOpacityVal,
                                onPressed: () =>
                                    _startPullAnimation('register'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
              ),

              // Чёрный overlay
              if (overlayVal > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withOpacity(
                        overlayVal.clamp(0.0, 1.0),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Icon icon,
    required bool isClicked,
    required double scale,
    required double opacity,
    required VoidCallback onPressed,
  }) {
    if (!_isAnimating) {
      return NebulaGlassButton(text: text, icon: icon, onPressed: onPressed);
    }

    return Transform.scale(
      scale: scale.clamp(0.0, 1.0),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: NebulaGlassButton(text: text, icon: icon, onPressed: () {}),
      ),
    );
  }
}
