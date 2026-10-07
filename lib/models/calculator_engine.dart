class CalculatorEngine {
  double? _accumulator;
  String _currentOperand = '0';
  String? _pendingOperator;
  bool _awaitingNextOperand = false;
  bool _isResultPhase = false;
  String? _errorMessage;
  String _expressionTrail = '';

  // Getters
  double? get accumulator => _accumulator;
  String get currentOperand => _currentOperand;
  String? get pendingOperator => _pendingOperator;
  bool get awaitingNextOperand => _awaitingNextOperand;
  bool get isResultPhase => _isResultPhase;
  String? get errorMessage => _errorMessage;
  String get expressionTrail => _expressionTrail;

  /// Returns the primary display string: either an error or current value
  String get displayValue {
    if (_errorMessage != null) {
      return _errorMessage!;
    }
    return _currentOperand;
  }

  /// Whether the clear button should display 'C' (Clear Entry) or 'AC' (All Clear)
  bool get canClearEntry {
    return _errorMessage == null &&
        !_isResultPhase &&
        !_awaitingNextOperand &&
        _currentOperand != '0';
  }

  /// Handles a numeric digit input ('0'-'9')
  void inputDigit(String digit) {
    if (_errorMessage != null) {
      allClear();
    }

    if (_isResultPhase) {
      // Core contract: A digit after equals starts a fresh calculation
      _accumulator = null;
      _pendingOperator = null;
      _isResultPhase = false;
      _currentOperand = digit;
      _awaitingNextOperand = false;
      _expressionTrail = digit;
      return;
    }

    if (_awaitingNextOperand) {
      // Core contract: A digit after an operator starts the next operand
      _currentOperand = digit;
      _awaitingNextOperand = false;
      _updateExpressionTrail();
      return;
    }

    // Appending digit to current operand
    if (_currentOperand == '0') {
      _currentOperand = digit;
    } else {
      // Cap length to avoid overflow
      if (_currentOperand.length < 12) {
        _currentOperand += digit;
      }
    }
    _updateExpressionTrail();
  }

  /// Handles decimal point input '.'
  void inputDecimal() {
    if (_errorMessage != null || _isResultPhase) {
      allClear();
      _currentOperand = '0.';
      _isResultPhase = false;
      _awaitingNextOperand = false;
      _updateExpressionTrail();
      return;
    }

    if (_awaitingNextOperand) {
      _currentOperand = '0.';
      _awaitingNextOperand = false;
      _updateExpressionTrail();
      return;
    }

    if (!_currentOperand.contains('.')) {
      _currentOperand += '.';
      _updateExpressionTrail();
    }
  }

  /// Handles arithmetic operators (+, -, ×, ÷)
  void inputOperator(String op) {
    if (_errorMessage != null) {
      return;
    }

    // Normalized display operator symbols
    final normalizedOp = _normalizeOperator(op);

    if (_isResultPhase) {
      // Continuing calculation from previous result
      _isResultPhase = false;
      _accumulator = double.tryParse(_currentOperand) ?? 0.0;
      _pendingOperator = normalizedOp;
      _awaitingNextOperand = true;
      _expressionTrail = '${_formatNumber(_accumulator!)} $normalizedOp';
      return;
    }

    if (_pendingOperator != null && _awaitingNextOperand) {
      // Core contract: Choosing an operator twice before entering another digit
      // replaces the pending operator (e.g. 9 + × 2 = replaces + with ×)
      _pendingOperator = normalizedOp;
      _updateExpressionTrail();
      return;
    }

    final double currentValue = double.tryParse(_currentOperand) ?? 0.0;

    if (_accumulator == null) {
      // First operand committed
      _accumulator = currentValue;
      _pendingOperator = normalizedOp;
      _awaitingNextOperand = true;
      _updateExpressionTrail();
    } else if (_pendingOperator != null) {
      // Core contract: choosing another operator after an operand first applies
      // the pending operation left to right and displays running total
      final double? result = _evaluate(_accumulator!, currentValue, _pendingOperator!);
      if (result == null) {
        // Error occurred (e.g. division by zero)
        return;
      }

      _accumulator = result;
      _currentOperand = _formatNumber(result);
      _pendingOperator = normalizedOp;
      _awaitingNextOperand = true;
      _expressionTrail = '${_formatNumber(result)} $normalizedOp';
    }
  }

  /// Handles equals (=) evaluation
  void inputEquals() {
    if (_errorMessage != null) {
      return;
    }

    // Core contract: Equals with no new operand is ignored
    if (_awaitingNextOperand) {
      return;
    }

    if (_accumulator != null && _pendingOperator != null) {
      final double currentValue = double.tryParse(_currentOperand) ?? 0.0;
      final double? result = _evaluate(_accumulator!, currentValue, _pendingOperator!);
      if (result == null) {
        return;
      }

      final opUsed = _pendingOperator!;
      _expressionTrail = '${_formatNumber(_accumulator!)} $opUsed ${_formatNumber(currentValue)} =';
      _accumulator = null;
      _pendingOperator = null;
      _currentOperand = _formatNumber(result);
      _awaitingNextOperand = false;
      _isResultPhase = true;
    }
  }

  /// Clear Entry: Clears only the current active operand to '0'
  void clearEntry() {
    if (_errorMessage != null) {
      allClear();
      return;
    }
    _currentOperand = '0';
    _updateExpressionTrail();
  }

  /// All Clear: Resets the display, accumulator, pending operator, and result phase
  void allClear() {
    _accumulator = null;
    _currentOperand = '0';
    _pendingOperator = null;
    _awaitingNextOperand = false;
    _isResultPhase = false;
    _errorMessage = null;
    _expressionTrail = '';
  }

  /// Positive/Negative sign toggle (±)
  void toggleSign() {
    if (_errorMessage != null) return;
    if (_currentOperand == '0' || _currentOperand == '0.') return;

    if (_currentOperand.startsWith('-')) {
      _currentOperand = _currentOperand.substring(1);
    } else {
      _currentOperand = '-$_currentOperand';
    }
    _updateExpressionTrail();
  }

  /// Percentage calculation (%)
  void inputPercent() {
    if (_errorMessage != null) return;
    final double value = double.tryParse(_currentOperand) ?? 0.0;
    final double percentValue = value / 100.0;
    _currentOperand = _formatNumber(percentValue);
    _updateExpressionTrail();
  }

  /// Backspace / Delete last digit
  void backspace() {
    if (_errorMessage != null || _isResultPhase || _awaitingNextOperand) {
      return;
    }
    if (_currentOperand.length > 1) {
      _currentOperand = _currentOperand.substring(0, _currentOperand.length - 1);
      if (_currentOperand == '-' || _currentOperand.isEmpty) {
        _currentOperand = '0';
      }
    } else {
      _currentOperand = '0';
    }
    _updateExpressionTrail();
  }

  double? _evaluate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
      case '*':
        return a * b;
      case '÷':
      case '/':
        if (b == 0.0) {
          _errorMessage = 'Error';
          _currentOperand = 'Error';
          _expressionTrail = 'Division by zero';
          return null;
        }
        return a / b;
      default:
        return b;
    }
  }

  void _updateExpressionTrail() {
    if (_accumulator != null && _pendingOperator != null) {
      if (_awaitingNextOperand) {
        _expressionTrail = '${_formatNumber(_accumulator!)} $_pendingOperator';
      } else {
        _expressionTrail = '${_formatNumber(_accumulator!)} $_pendingOperator $_currentOperand';
      }
    } else {
      _expressionTrail = _currentOperand;
    }
  }

  String _normalizeOperator(String op) {
    if (op == '*') return '×';
    if (op == '/') return '÷';
    return op;
  }

  String _formatNumber(double number) {
    // Avoid -0.0
    if (number.abs() < 1e-12) return '0';

    // Check if integer
    if (number == number.roundToDouble() && number.abs() < 1e12) {
      return number.toInt().toString();
    }

    // Format with clean precision without floating point inaccuracies
    String formatted = number.toStringAsPrecision(10);
    if (formatted.contains('.')) {
      // Remove trailing zeroes
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }
    return formatted;
  }
}
