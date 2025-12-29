import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism кнопка — стеклянно-матовая с затемнением
/// Используется для OAuth кнопок (Google, Apple) и вторичных действий
class NebulaGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color backgroundColor;
  final Color borderColor;

  const NebulaGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
    this.blur = 15,
    this.backgroundColor = Colors.transparent,
    this.borderColor = const Color.fromARGB(255, 191, 64, 255),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: 0.6),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            icon!,
                            const SizedBox(width: 12),
                          ],
                          Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
