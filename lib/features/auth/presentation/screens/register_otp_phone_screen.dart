import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nebula/features/auth/data/datasources/auth_service.dart';
import 'package:nebula/features/auth/data/models/registration_data.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/nebula_background.dart';
import 'package:nebula/shared/widgets/glass_container.dart';
import 'package:nebula/shared/widgets/nebula_button.dart';
import 'package:nebula/shared/widgets/nebula_logo.dart';
import 'register_password_screen.dart';

/// Шаг 2: Проверка OTP кода по телефону (Firebase Phone Auth)
class RegisterOtpPhoneScreen extends StatefulWidget {
  final RegistrationData data;

  const RegisterOtpPhoneScreen({super.key, required this.data});

  @override
  State<RegisterOtpPhoneScreen> createState() => _RegisterOtpPhoneScreenState();
}

class _RegisterOtpPhoneScreenState extends State<RegisterOtpPhoneScreen> {
  bool _isLoading = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  final _authService = AuthService();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    if (_code.length != 6) {
      AppNotification.showError(context, 'Введите 6-значный код');
      return;
    }

    if (widget.data.verificationId == null) {
      AppNotification.showError(context, 'Ошибка верификации');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Создаём credential с кодом
      final credential = _authService.getPhoneCredential(
        verificationId: widget.data.verificationId!,
        smsCode: _code,
      );

      // Входим по телефону (создаётся аккаунт если нет)
      await _authService.signInWithPhoneCredential(credential);

      if (mounted) {
        // Переходим на экран создания пароля
        // Телефон уже привязан, теперь нужно добавить пароль
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterPasswordScreen(data: widget.data),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotification.showError(context, 'Неверный код: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    if (_secondsRemaining > 0) return;

    setState(() => _isLoading = true);

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: widget.data.phone,
        resendToken: widget.data.resendToken,
        onCodeSent: (verificationId, resendToken) {
          if (mounted) {
            setState(() => _isLoading = false);
            widget.data.verificationId = verificationId;
            widget.data.resendToken = resendToken;
            AppNotification.showSuccess(context, 'Код отправлен повторно');
            _startTimer();
          }
        },
        onVerificationCompleted: (_) {},
        onVerificationFailed: (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            AppNotification.showError(
              context,
              'Ошибка: ${e.message ?? e.code}',
            );
          }
        },
        onCodeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppNotification.showError(context, 'Ошибка: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
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
                        const NebulaLogo(logoSize: 60, fontSize: 23),
                        const SizedBox(height: 8),
                        Text(
                          'Подтверждение',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Шаг 2 из 5',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Код отправлен на',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.phone,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // OTP поля
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 35,
                              height: 55,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                  if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                  if (_code.length == 6) {
                                    _verifyCode();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        // Кнопка подтвердить
                        SizedBox(
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : NebulaGlassButton(
                                  text: 'Подтвердить',
                                  icon: const Icon(Icons.check, size: 20),
                                  onPressed: _verifyCode,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Повторная отправка
                        TextButton(
                          onPressed: _secondsRemaining == 0
                              ? _resendCode
                              : null,
                          child: Text(
                            _secondsRemaining > 0
                                ? 'Отправить повторно ($_secondsRemaining с)'
                                : 'Отправить повторно',
                            style: TextStyle(
                              color: _secondsRemaining > 0
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.7),
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
