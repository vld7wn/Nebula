import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism контейнер — матовое стекло
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.blur = 25,
    this.opacity = 0.15,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: CustomPaint(
            painter: _GlassBorderPainter(borderRadius: borderRadius),
            child: Container(
              padding: padding ?? const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // Матовый фон
                color: Color.lerp(
                  Colors.white.withOpacity(opacity),
                  Colors.black.withOpacity(opacity * 0.5),
                  0.3,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Рисует градиентную границу для эффекта освещения
class _GlassBorderPainter extends CustomPainter {
  final double borderRadius;

  _GlassBorderPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Градиент для границы — ярче сверху
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.1)],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
