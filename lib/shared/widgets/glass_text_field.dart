import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphism поле ввода
class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final FocusNode? focusNode;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            enabled: enabled,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
              labelStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: Colors.white.withOpacity(0.7),
                      size: 22,
                    )
                  : null,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
