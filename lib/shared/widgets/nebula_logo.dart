import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Виджет логотипа Nebula Messenger
/// Рисует стилизованную букву "N" с текстом "Nebula Messenger"
class NebulaLogo extends StatelessWidget {
  /// Размер логотипа (иконки N)
  final double? logoSize;

  /// Размер шрифта текста
  final double? fontSize;

  /// Показывать ли текст (для компактного режима)
  final bool showText;

  /// Ориентация: горизонтальная (Row) или вертикальная (Column)
  final Axis orientation;

  const NebulaLogo({
    super.key,
    this.logoSize,
    this.fontSize,
    this.showText = true,
    this.orientation = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Адаптивные размеры по умолчанию
    final effectiveLogoSize = logoSize ?? (screenWidth < 400 ? 100.0 : 150.0);
    final effectiveFontSize = fontSize ?? (screenWidth < 400 ? 36.0 : 46.0);
    final spacing = screenWidth < 400 ? 12.0 : 20.0;

    final logoWidget = Image.asset(
      'assets/images/logo/nebula_n_transparent.png',
      width: effectiveLogoSize,
      height: effectiveLogoSize,
      fit: BoxFit.contain,
    );

    if (!showText) {
      return logoWidget;
    }

    final textWidget = Column(
      crossAxisAlignment: orientation == Axis.horizontal
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Nebula',
          style: GoogleFonts.archivo(
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 0),
        Text(
          'Messenger',
          style: GoogleFonts.archivo(
            fontSize: effectiveFontSize,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            letterSpacing: 4,
            height: 1,
          ),
        ),
      ],
    );

    if (orientation == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          SizedBox(height: spacing),
          textWidget,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        SizedBox(width: spacing),
        textWidget,
      ],
    );
  }
}
