import 'package:flutter/material.dart';
import 'package:calculator_app/theme/calculator_theme.dart';
import 'package:calculator_app/widgets/theme_morph_button.dart';

class CalculatorHeader extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final CalcThemeData theme;

  const CalculatorHeader({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Clean "Calculator" Title
          Text(
            'Calculator',
            style: TextStyle(
              fontFamily: 'AktivGrotesk',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: theme.titleColor,
            ),
          ),

          // Right: Morphing Animated Theme Toggle Button
          ThemeMorphButton(
            isDarkMode: isDarkMode,
            onThemeChanged: onThemeChanged,
            iconColor: isDarkMode ? const Color(0xFFFF9500) : theme.iconColor,
          ),
        ],
      ),
    );
  }
}
