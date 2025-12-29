import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Космический фон с анимированной чёрной дырой (FragmentShader)
class NebulaBackground extends StatefulWidget {
  final Widget child;
  final bool animated;
  final double pullStrength; // 0.0 = нормально, 1.0 = максимальное засасывание

  const NebulaBackground({
    super.key,
    required this.child,
    this.animated = true,
    this.pullStrength = 0.0,
  });

  @override
  State<NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<NebulaBackground>
    with SingleTickerProviderStateMixin {
  ui.FragmentShader? _shader;
  late Ticker _ticker;
  double _time = 0;
  bool _shaderLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadShader();

    _ticker = createTicker((elapsed) {
      if (widget.animated && _shaderLoaded) {
        setState(() {
          _time = elapsed.inMilliseconds / 1000.0;
        });
      }
    });

    if (widget.animated) {
      _ticker.start();
    }
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset(
        'shaders/black_hole.frag',
      );
      setState(() {
        _shader = program.fragmentShader();
        _shaderLoaded = true;
      });
    } catch (e) {
      debugPrint('Shader loading failed: $e');
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_shaderLoaded && _shader != null)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _BlackHoleShaderPainter(
                  shader: _shader!,
                  time: _time,
                  pullStrength: widget.pullStrength,
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D0D1A),
                    Color(0xFF1A0D2E),
                    Color(0xFF0A0A14),
                  ],
                ),
              ),
            ),
          ),
        widget.child,
      ],
    );
  }
}

class _BlackHoleShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double time;
  final double pullStrength;

  _BlackHoleShaderPainter({
    required this.shader,
    required this.time,
    required this.pullStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width); // uResolution.x
    shader.setFloat(1, size.height); // uResolution.y
    shader.setFloat(2, time); // uTime
    shader.setFloat(3, pullStrength); // uPullStrength

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _BlackHoleShaderPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.pullStrength != pullStrength;
  }
}
