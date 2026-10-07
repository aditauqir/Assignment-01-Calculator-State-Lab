import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_app/models/calculator_engine.dart';
import 'package:calculator_app/theme/calculator_theme.dart';
import 'package:calculator_app/widgets/calculator_header.dart';
import 'package:calculator_app/widgets/calculator_screen.dart';
import 'package:calculator_app/widgets/tactile_button.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = true;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = _isDarkMode ? CalcThemeData.dark : CalcThemeData.light;

    return MaterialApp(
      title: 'Calculator State Lab',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: CalcThemeData.light.bg,
        fontFamily: 'AktivGrotesk',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: CalcThemeData.dark.bg,
        fontFamily: 'AktivGrotesk',
      ),
      home: CalculatorHomePage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
        theme: currentTheme,
      ),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final CalcThemeData theme;

  const CalculatorHomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.theme,
  });

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  final CalculatorEngine _engine = CalculatorEngine();

  void _onDigitPressed(String digit) {
    setState(() {
      _engine.inputDigit(digit);
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      _engine.inputOperator(op);
    });
  }

  void _onEqualsPressed() {
    setState(() {
      _engine.inputEquals();
    });
  }

  void _onClearPressed() {
    setState(() {
      if (_engine.canClearEntry) {
        _engine.clearEntry();
      } else {
        _engine.allClear();
      }
    });
  }

  void _onAllClearPressed() {
    setState(() {
      _engine.allClear();
    });
  }

  void _onDecimalPressed() {
    setState(() {
      _engine.inputDecimal();
    });
  }

  void _onPercentPressed() {
    setState(() {
      _engine.inputPercent();
    });
  }

  void _onToggleSignPressed() {
    setState(() {
      _engine.toggleSign();
    });
  }

  void _onBackspacePressed() {
    setState(() {
      _engine.backspace();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final clearLabel = _engine.canClearEntry ? 'C' : 'AC';

    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              // Top Minimalist Header (Title, Theme Switch)
              CalculatorHeader(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: widget.onThemeChanged,
                theme: theme,
              ),

              // Seamless Display Area (Expression Trail + Large Readout)
              Expanded(
                flex: 2,
                child: CalculatorScreen(
                  displayValue: _engine.displayValue,
                  expressionTrail: _engine.expressionTrail,
                  errorMessage: _engine.errorMessage,
                  theme: theme,
                ),
              ),

              const SizedBox(height: 16),

              // 5x4 Grid Matrix matching the design mockup exactly
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    // Row 1: AC, ⌫, %, ÷
                    _buildButtonRow([
                      _buildButton(
                        label: clearLabel,
                        onTap: _onClearPressed,
                        onLongPress: _onAllClearPressed,
                        isAction: true,
                      ),
                      _buildButton(
                        label: '⌫',
                        icon: const Icon(Icons.backspace_outlined, size: 22),
                        onTap: _onBackspacePressed,
                        isAction: true,
                      ),
                      _buildButton(
                        label: '%',
                        onTap: _onPercentPressed,
                        isAction: true,
                      ),
                      _buildButton(
                        label: '÷',
                        onTap: () => _onOperatorPressed('÷'),
                        isOperator: true,
                      ),
                    ]),

                    // Row 2: 7, 8, 9, ×
                    _buildButtonRow([
                      _buildButton(label: '7', onTap: () => _onDigitPressed('7'), isNumber: true),
                      _buildButton(label: '8', onTap: () => _onDigitPressed('8'), isNumber: true),
                      _buildButton(label: '9', onTap: () => _onDigitPressed('9'), isNumber: true),
                      _buildButton(
                        label: '×',
                        onTap: () => _onOperatorPressed('×'),
                        isOperator: true,
                      ),
                    ]),

                    // Row 3: 4, 5, 6, −
                    _buildButtonRow([
                      _buildButton(label: '4', onTap: () => _onDigitPressed('4'), isNumber: true),
                      _buildButton(label: '5', onTap: () => _onDigitPressed('5'), isNumber: true),
                      _buildButton(label: '6', onTap: () => _onDigitPressed('6'), isNumber: true),
                      _buildButton(
                        label: '−',
                        onTap: () => _onOperatorPressed('-'),
                        isOperator: true,
                      ),
                    ]),

                    // Row 4: 1, 2, 3, +
                    _buildButtonRow([
                      _buildButton(label: '1', onTap: () => _onDigitPressed('1'), isNumber: true),
                      _buildButton(label: '2', onTap: () => _onDigitPressed('2'), isNumber: true),
                      _buildButton(label: '3', onTap: () => _onDigitPressed('3'), isNumber: true),
                      _buildButton(
                        label: '+',
                        onTap: () => _onOperatorPressed('+'),
                        isOperator: true,
                      ),
                    ]),

                    // Row 5: ±, 0, ., =
                    _buildButtonRow([
                      _buildButton(
                        label: '±',
                        onTap: _onToggleSignPressed,
                        isAction: true,
                      ),
                      _buildButton(
                        label: '0',
                        onTap: () => _onDigitPressed('0'),
                        isNumber: true,
                      ),
                      _buildButton(
                        label: '.',
                        onTap: _onDecimalPressed,
                        isNumber: true,
                      ),
                      _buildButton(
                        label: '=',
                        onTap: _onEqualsPressed,
                        isOperator: true,
                      ),
                    ]),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((btn) => Expanded(child: btn)).toList(),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    Widget? icon,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    bool isOperator = false,
    bool isAction = false,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TactileButton(
        label: label,
        icon: icon,
        onTap: onTap,
        onLongPress: onLongPress,
        theme: widget.theme,
        isOperator: isOperator,
        isAction: isAction,
        isNumber: isNumber,
      ),
    );
  }
}
