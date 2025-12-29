import 'package:flutter/material.dart';
import 'glass_text_field.dart';


/// Glassmorphism поле пароля с переключателем видимости
class GlassPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const GlassPasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.validator,
    this.onChanged,
  });

  @override
  State<GlassPasswordField> createState() => _GlassPasswordFieldState();
}

class _GlassPasswordFieldState extends State<GlassPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassTextField(
      controller: widget.controller,
      hintText: widget.hintText ?? 'Пароль',
      prefixIcon: Icons.lock_outline,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      suffixIcon: GestureDetector(
        onTap: _toggleVisibility,
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.white.withOpacity(0.7),
          size: 22,
        ),
      ),
    );
  }
}
