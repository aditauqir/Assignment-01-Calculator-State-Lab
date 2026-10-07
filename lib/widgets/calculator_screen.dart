import 'package:flutter/material.dart';
import 'package:calculator_app/theme/calculator_theme.dart';

class CalculatorScreen extends StatelessWidget {
  final String displayValue;
  final String expressionTrail;
  final String? errorMessage;
  final CalcThemeData theme;

  const CalculatorScreen({
    super.key,
    required this.displayValue,
    required this.expressionTrail,
    required this.errorMessage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorMessage != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Secondary running total / expression trail
          SizedBox(
            height: 24,
            child: Text(
              expressionTrail.isEmpty ? ' ' : expressionTrail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'AktivGrotesk',
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: hasError
                    ? const Color(0xFFFF3B30)
                    : theme.displaySubText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Primary large number readout: FittedBox inside Expanded ensures zero overflow on any device
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  displayValue,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'AktivGrotesk',
                    fontSize: 72,
                    fontWeight: FontWeight.w600,
                    color: hasError ? const Color(0xFFFF3B30) : theme.displayText,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
