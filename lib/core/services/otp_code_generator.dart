import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Генератор одноразовых кодов для регистрации
/// Код генерируется локально и меняется:
/// - При истечении таймера (20 сек)
/// - При сворачивании приложения
/// - При закрытии приложения
class OtpCodeGenerator extends ChangeNotifier {
  static const int codeLength = 6;
  static const int validitySeconds = 20;

  final Random _random = Random.secure();

  String _currentCode = '';
  int _remainingSeconds = validitySeconds;
  Timer? _timer;

  /// Текущий одноразовый код
  String get currentCode => _currentCode;

  /// Оставшееся время в секундах
  int get remainingSeconds => _remainingSeconds;

  /// Прогресс таймера (от 1.0 до 0.0)
  double get progress => _remainingSeconds / validitySeconds;

  OtpCodeGenerator() {
    generateNewCode();
  }

  /// Генерация нового 6-значного кода
  void generateNewCode() {
    final buffer = StringBuffer();
    for (int i = 0; i < codeLength; i++) {
      buffer.write(_random.nextInt(10));
    }
    _currentCode = buffer.toString();
    _remainingSeconds = validitySeconds;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      if (_remainingSeconds <= 0) {
        generateNewCode();
      } else {
        notifyListeners();
      }
    });
  }

  /// Вызывается при сворачивании приложения
  void onAppPaused() {
    generateNewCode();
  }

  /// Вызывается при возврате в приложение
  void onAppResumed() {
    // Можно добавить логику если нужно
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
