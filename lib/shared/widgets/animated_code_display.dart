import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nebula/core/services/otp_code_generator.dart';
import 'package:nebula/shared/utils/app_notification.dart';
import 'package:nebula/shared/widgets/glass_container.dart';

/// Виджет отображения одноразового кода с анимацией прокрутки
/// Формат: XXX-XXX
/// Каждая цифра появляется последовательно с эффектом "слот-машины"
class AnimatedCodeDisplay extends StatefulWidget {
  final OtpCodeGenerator generator;

  const AnimatedCodeDisplay({super.key, required this.generator});

  @override
  State<AnimatedCodeDisplay> createState() => _AnimatedCodeDisplayState();
}

class _AnimatedCodeDisplayState extends State<AnimatedCodeDisplay>
    with TickerProviderStateMixin {
  late List<AnimationController> _digitControllers;
  late List<Animation<double>> _digitAnimations;

  bool _showCopyButton = false;
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    _currentCode = widget.generator.currentCode;
    _initAnimations();
    widget.generator.addListener(_onCodeChanged);

    // Запускаем анимацию при первой загрузке
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRevealAnimation();
    });
  }

  void _initAnimations() {
    _digitControllers = List.generate(6, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + index * 200),
        vsync: this,
      );
    });

    _digitAnimations = _digitControllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    }).toList();
  }

  void _onCodeChanged() {
    if (_currentCode != widget.generator.currentCode) {
      _currentCode = widget.generator.currentCode;
      _startRevealAnimation();
    }
  }

  void _startRevealAnimation() {
    setState(() => _showCopyButton = false);

    // Сброс анимаций
    for (var controller in _digitControllers) {
      controller.reset();
    }

    // Последовательный запуск анимаций
    for (int i = 0; i < 6; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (mounted) {
          _digitControllers[i].forward();
        }
      });
    }

    // Показываем кнопку копирования после всех анимаций
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() => _showCopyButton = true);
      }
    });
  }

  @override
  void dispose() {
    widget.generator.removeListener(_onCodeChanged);
    for (var controller in _digitControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.generator,
      builder: (context, _) {
        return GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.vpn_key_outlined,
                    color: Colors.white.withOpacity(0.5),
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Код для регистрации',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Код с анимацией
              _buildCodeDisplay(),

              const SizedBox(height: 16),

              // Таймер
              _buildTimer(),

              // Кнопка копирования
              AnimatedOpacity(
                opacity: _showCopyButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSlide(
                  offset: _showCopyButton ? Offset.zero : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildCopyButton(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCodeDisplay() {
    final digits = _currentCode.split('');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Первые 3 цифры
        ...List.generate(3, (i) => _buildDigitCell(digits[i], i)),

        // Тире
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),

        // Последние 3 цифры
        ...List.generate(3, (i) => _buildDigitCell(digits[i + 3], i + 3)),
      ],
    );
  }

  Widget _buildDigitCell(String digit, int index) {
    return AnimatedBuilder(
      animation: _digitAnimations[index],
      builder: (context, child) {
        final progress = _digitAnimations[index].value;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 38,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08 + progress * 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.1 + progress * 0.15),
            ),
            boxShadow: progress > 0.8
                ? [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2 * progress),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildAnimatedDigit(digit, progress),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDigit(String targetDigit, double progress) {
    if (progress >= 1.0) {
      // Анимация завершена — показываем цифру
      return Center(
        child: Text(
          targetDigit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      );
    }

    // Анимация прокрутки
    final target = int.tryParse(targetDigit) ?? 0;
    final scrollOffset = (1.0 - progress) * 20; // Количество "прокруток"
    final currentDigit = ((target + scrollOffset) % 10).floor();

    return Stack(
      children: [
        // Текущая "прокручивающаяся" цифра
        Center(
          child: Opacity(
            opacity: 0.3 + progress * 0.7,
            child: Transform.translate(
              offset: Offset(0, (1.0 - progress) * 5),
              child: Text(
                currentDigit.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
        // Motion blur эффект
        if (progress < 0.7)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.withOpacity(0.1 * (1 - progress)),
                    Colors.transparent,
                    Colors.purple.withOpacity(0.1 * (1 - progress)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimer() {
    final seconds = widget.generator.remainingSeconds;
    final progress = widget.generator.progress;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTimerColor(seconds),
              ),
              minHeight: 3,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$seconds сек',
          style: TextStyle(
            color: _getTimerColor(seconds),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCopyButton() {
    return GestureDetector(
      onTap: _copyCode,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Скопировать',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTimerColor(int seconds) {
    if (seconds <= 5) return Colors.red.shade400;
    if (seconds <= 10) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _currentCode));
    AppNotification.showSuccess(context, 'Код скопирован!');
  }
}
