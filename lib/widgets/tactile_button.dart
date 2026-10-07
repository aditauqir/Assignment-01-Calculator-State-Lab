import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_app/theme/calculator_theme.dart';

class TactileButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final CalcThemeData theme;
  final bool isOperator;
  final bool isAction;
  final bool isNumber;

  const TactileButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.onLongPress,
    required this.theme,
    this.isOperator = false,
    this.isAction = false,
    this.isNumber = false,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    // Determine text and icon color
    Color textColor;
    if (widget.isOperator) {
      textColor = theme.operatorText;
    } else if (widget.isAction) {
      textColor = theme.actionText;
    } else {
      textColor = theme.textPrimary;
    }

    // Clean background without glow, just crisp border lines
    Color btnColor;
    if (_isPressed) {
      btnColor = theme.buttonActiveBg;
    } else {
      btnColor = theme.buttonBg;
    }

    return Semantics(
      button: true,
      label: _semanticLabel,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 1.0, // Ensures buttons are strict squares no matter what screen size
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          onLongPress: () {
            HapticFeedback.mediumImpact();
            widget.onLongPress?.call();
          },
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 70),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 70),
              decoration: BoxDecoration(
                color: btnColor,
                borderRadius: BorderRadius.circular(16),
                // Clean border lines only - ZERO glow / shadow
                border: Border.all(
                  color: _isPressed
                      ? (widget.isOperator
                            ? theme.operatorText.withValues(alpha: 0.5)
                            : theme.borderStroke)
                      : theme.borderStroke,
                  width: 1.2,
                ),
                // Absolutely no box shadow/glow
                boxShadow: const [],
              ),
              child: Center(
                child: widget.icon != null
                    ? IconTheme(
                        data: IconThemeData(color: textColor, size: 24),
                        child: widget.icon!,
                      )
                    : Text(
                        widget.label,
                        style: TextStyle(
                          fontFamily: widget.isNumber ? 'AktivGrotesk' : null,
                          fontSize: widget.isNumber
                              ? 28
                              : (widget.isOperator ? 28 : 22),
                          fontWeight: widget.isNumber
                              ? FontWeight.w500
                              : (widget.isOperator
                                    ? FontWeight.w500
                                    : FontWeight.w600),
                          color: textColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _semanticLabel {
    switch (widget.label) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        return 'Digit ${widget.label}';
      case '+':
        return 'Plus';
      case '-':
      case '−':
        return 'Minus';
      case '×':
        return 'Times';
      case '÷':
        return 'Divided by';
      case '=':
        return 'Equals';
      case 'C':
        return 'Clear entry';
      case 'AC':
        return 'All clear';
      case '±':
        return 'Plus or minus';
      case '%':
        return 'Percent';
      case '⌫':
        return 'Backspace';
      case '.':
        return 'Decimal point';
      default:
        return widget.label;
    }
  }
}
