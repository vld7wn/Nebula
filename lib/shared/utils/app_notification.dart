import 'package:flutter/material.dart';
import 'package:nebula/shared/widgets/glass_container.dart';

/// Утилита для показа уведомлений в стиле glassmorphism
class AppNotification {
  /// Показать уведомление об успехе
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      iconColor: Colors.green.shade400,
      icon: Icons.check_circle_outline,
    );
  }

  /// Показать уведомление об ошибке
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      iconColor: Colors.red.shade400,
      icon: Icons.error_outline,
    );
  }

  /// Показать информационное уведомление
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      iconColor: Colors.blue.shade400,
      icon: Icons.info_outline,
    );
  }

  /// Показать предупреждение
  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      iconColor: Colors.orange.shade400,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color iconColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GlassContainer(
          borderRadius: 16,
          blur: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
