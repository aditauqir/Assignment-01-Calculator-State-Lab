import 'package:flutter/material.dart';

class CalcThemeData {
  final bool isDark;
  final Color bg;
  final Color displayBg;
  final Color displayText;
  final Color displaySubText;
  final Color titleColor;
  final Color buttonBg;
  final Color buttonActiveBg;
  final Color operatorText;
  final Color actionText;
  final Color accentColor;
  final Color textPrimary;
  final Color iconColor;
  final Color borderStroke;

  const CalcThemeData({
    required this.isDark,
    required this.bg,
    required this.displayBg,
    required this.displayText,
    required this.displaySubText,
    required this.titleColor,
    required this.buttonBg,
    required this.buttonActiveBg,
    required this.operatorText,
    required this.actionText,
    required this.accentColor,
    required this.textPrimary,
    required this.iconColor,
    required this.borderStroke,
  });

  // Palette: #000000 (Black), #F5DAFF (Lavender), #97C0F3 (Sky Blue), #FFF6FB (Pale Pink-White)
  static const dark = CalcThemeData(
    isDark: true,
    bg: Color(0xFF000000), // Pure Black Background requested
    displayBg: Colors.transparent,
    displayText: Color(0xFFFFF6FB), // #FFF6FB Crisp Digits
    displaySubText: Color(0xFF97C0F3), // #97C0F3 Expression Trail
    titleColor: Color(0xFFF5DAFF), // #F5DAFF Lavender Header Title
    buttonBg: Color(0xFF08080A), // Black chassis button
    buttonActiveBg: Color(0xFF1C1D24),
    operatorText: Color(0xFF97C0F3), // #97C0F3 Sky Blue for Operators (÷, ×, −, +, =)
    actionText: Color(0xFFF5DAFF), // #F5DAFF Lavender for Actions (AC, ⌫, %, ±)
    accentColor: Color(0xFF97C0F3),
    textPrimary: Color(0xFFFFF6FB), // #FFF6FB Digits
    iconColor: Color(0xFFF5DAFF),
    borderStroke: Color(0xFF1E2028), // Crisp clean lines
  );

  static const light = CalcThemeData(
    isDark: false,
    bg: Color(0xFFFFF6FB), // #FFF6FB Pale Pink-White Background
    displayBg: Colors.transparent,
    displayText: Color(0xFF000000), // #000000 Pure Black Digits
    displaySubText: Color(0xFF7E8492),
    titleColor: Color(0xFF6366F1),
    buttonBg: Color(0xFFFFFFFF),
    buttonActiveBg: Color(0xFFF5DAFF),
    operatorText: Color(0xFF3B82F6), // #97C0F3 deeper contrast for light mode
    actionText: Color(0xFF8B5CF6), // #F5DAFF deeper contrast for light mode
    accentColor: Color(0xFF3B82F6),
    textPrimary: Color(0xFF000000), // #000000 Black Digits
    iconColor: Color(0xFF4B5563),
    borderStroke: Color(0xFFEDE2EC), // Crisp clean lines
  );
}
