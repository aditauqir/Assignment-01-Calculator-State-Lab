import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_app/widgets/app_icons.dart';

class ThemeMorphButton extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Color iconColor;

  const ThemeMorphButton({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final semanticLabel = isDarkMode
        ? 'Switch to light mode'
        : 'Switch to dark mode';

    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: IconButton(
        splashRadius: 24,
        tooltip: semanticLabel,
        onPressed: () {
          HapticFeedback.lightImpact();
          onThemeChanged(!isDarkMode);
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: isDarkMode
              ? SizedBox(
                  key: const ValueKey('sun_icon'),
                  width: 24,
                  height: 24,
                  child: AppIcons.lightMode(color: iconColor, size: 24),
                )
              : SizedBox(
                  key: const ValueKey('moon_icon'),
                  width: 24,
                  height: 24,
                  child: AppIcons.darkMode(color: iconColor, size: 24),
                ),
        ),
      ),
    );
  }
}
