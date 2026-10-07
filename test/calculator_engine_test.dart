import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/models/calculator_engine.dart';

void main() {
  group('Calculator Core Contract & Left-to-Right Evaluation', () {
    late CalculatorEngine engine;

    setUp(() {
      engine = CalculatorEngine();
    });

    test('Initial state is clean', () {
      expect(engine.displayValue, '0');
      expect(engine.accumulator, isNull);
      expect(engine.pendingOperator, isNull);
      expect(engine.awaitingNextOperand, isFalse);
      expect(engine.isResultPhase, isFalse);
      expect(engine.errorMessage, isNull);
    });

    test('Single operand entry: 12', () {
      engine.inputDigit('1');
      expect(engine.displayValue, '1');
      engine.inputDigit('2');
      expect(engine.displayValue, '12');
    });

    test('Core flow: 2 + 3 × 4 = evaluates to 20 (Left-to-Right without precedence)', () {
      // 2
      engine.inputDigit('2');
      expect(engine.displayValue, '2');

      // +
      engine.inputOperator('+');
      expect(engine.accumulator, 2.0);
      expect(engine.pendingOperator, '+');
      expect(engine.awaitingNextOperand, isTrue);

      // 3
      engine.inputDigit('3');
      expect(engine.displayValue, '3');
      expect(engine.awaitingNextOperand, isFalse);

      // × (Should evaluate 2 + 3 = 5, display 5, store as new accumulator)
      engine.inputOperator('×');
      expect(engine.displayValue, '5');
      expect(engine.accumulator, 5.0);
      expect(engine.pendingOperator, '×');
      expect(engine.awaitingNextOperand, isTrue);

      // 4
      engine.inputDigit('4');
      expect(engine.displayValue, '4');
      expect(engine.awaitingNextOperand, isFalse);

      // = (Should evaluate 5 × 4 = 20)
      engine.inputEquals();
      expect(engine.displayValue, '20');
      expect(engine.isResultPhase, isTrue);
      expect(engine.accumulator, isNull);
      expect(engine.pendingOperator, isNull);
    });

    test('Repeated operators: 9 + × 2 = replaces + with ×, producing 18', () {
      engine.inputDigit('9');
      engine.inputOperator('+');
      expect(engine.pendingOperator, '+');

      // Operator entered twice before next digit replaces pending operator
      engine.inputOperator('×');
      expect(engine.pendingOperator, '×');
      expect(engine.accumulator, 9.0);

      engine.inputDigit('2');
      engine.inputEquals();
      expect(engine.displayValue, '18');
    });

    test('Equals with no new operand is ignored: 7 + = displays 7', () {
      engine.inputDigit('7');
      engine.inputOperator('+');
      expect(engine.displayValue, '7');
      expect(engine.pendingOperator, '+');

      // Pressing equals while awaiting operand is ignored
      engine.inputEquals();
      expect(engine.displayValue, '7');
      expect(engine.pendingOperator, '+');
      expect(engine.accumulator, 7.0);
    });

    test('Digit after equals starts a fresh calculation', () {
      // 5 + 5 = 10
      engine.inputDigit('5');
      engine.inputOperator('+');
      engine.inputDigit('5');
      engine.inputEquals();
      expect(engine.displayValue, '10');
      expect(engine.isResultPhase, isTrue);

      // New digit tap starts fresh calculation
      engine.inputDigit('3');
      expect(engine.displayValue, '3');
      expect(engine.isResultPhase, isFalse);
      expect(engine.accumulator, isNull);
      expect(engine.pendingOperator, isNull);
    });
  });

  group('Undergraduate Pathway Features Verification', () {
    late CalculatorEngine engine;

    setUp(() {
      engine = CalculatorEngine();
    });

    test('Feature 02: Clear Entry (C) resets current operand without losing accumulator', () {
      engine.inputDigit('8');
      engine.inputOperator('+');
      engine.inputDigit('9');
      expect(engine.displayValue, '9');
      expect(engine.canClearEntry, isTrue);

      // Clear entry resets only the 9 to 0
      engine.clearEntry();
      expect(engine.displayValue, '0');
      expect(engine.accumulator, 8.0);
      expect(engine.pendingOperator, '+');

      // Now enter 4 and evaluate
      engine.inputDigit('4');
      engine.inputEquals();
      expect(engine.displayValue, '12');
    });

    test('Feature 02: All Clear (AC) completely resets accumulator, operator, and state', () {
      engine.inputDigit('8');
      engine.inputOperator('+');
      engine.inputDigit('9');

      engine.allClear();
      expect(engine.displayValue, '0');
      expect(engine.accumulator, isNull);
      expect(engine.pendingOperator, isNull);
      expect(engine.awaitingNextOperand, isFalse);
      expect(engine.isResultPhase, isFalse);
      expect(engine.errorMessage, isNull);
    });

    test('Feature 03: Error handling on division by zero: 5 ÷ 0 = Error', () {
      engine.inputDigit('5');
      engine.inputOperator('÷');
      engine.inputDigit('0');
      engine.inputEquals();

      expect(engine.displayValue, 'Error');
      expect(engine.errorMessage, 'Error');

      // Error state recovery on new digit
      engine.inputDigit('7');
      expect(engine.displayValue, '7');
      expect(engine.errorMessage, isNull);
    });

    test('Feature 03: Division by zero within chained operations', () {
      engine.inputDigit('1');
      engine.inputDigit('0');
      engine.inputOperator('÷');
      engine.inputDigit('0');
      engine.inputOperator('+'); // Chained operator after zero division

      expect(engine.displayValue, 'Error');
      expect(engine.errorMessage, 'Error');

      // Recover by pressing AC
      engine.allClear();
      expect(engine.errorMessage, isNull);
      expect(engine.displayValue, '0');
    });

    test('Decimal input validation: prevents duplicate decimals', () {
      engine.inputDigit('3');
      engine.inputDecimal();
      engine.inputDigit('1');
      engine.inputDecimal(); // Duplicate decimal ignored
      engine.inputDigit('4');
      expect(engine.displayValue, '3.14');
    });

    test('Positive / Negative toggle (±)', () {
      engine.inputDigit('5');
      engine.toggleSign();
      expect(engine.displayValue, '-5');
      engine.toggleSign();
      expect(engine.displayValue, '5');
    });

    test('Percentage calculation (%)', () {
      engine.inputDigit('5');
      engine.inputDigit('0');
      engine.inputPercent();
      expect(engine.displayValue, '0.5');
    });

    test('Invariant verification: AC eliminates stale accumulator', () {
      // Trace: 15 + 3 = 18. Then AC. Then entering 4 + 2 = 6 (must not use 18)
      engine.inputDigit('1');
      engine.inputDigit('5');
      engine.inputOperator('+');
      engine.inputDigit('3');
      engine.inputEquals();
      expect(engine.displayValue, '18');

      engine.allClear();
      expect(engine.accumulator, isNull);

      engine.inputDigit('4');
      engine.inputOperator('+');
      engine.inputDigit('2');
      engine.inputEquals();
      expect(engine.displayValue, '6');
    });

    test('Gemini Proposed Test: 5 + 5 = AC 3 = evaluates to 3', () {
      engine.inputDigit('5');
      engine.inputOperator('+');
      engine.inputDigit('5');
      engine.inputEquals();
      expect(engine.displayValue, '10');

      engine.allClear();
      expect(engine.accumulator, isNull);

      engine.inputDigit('3');
      engine.inputEquals();
      expect(engine.displayValue, '3');
    });

    test('ChatGPT Proposed Test: 2 + 3 AC 4 + 5 = evaluates to 9', () {
      engine.inputDigit('2');
      engine.inputOperator('+');
      engine.inputDigit('3');

      engine.allClear();
      expect(engine.accumulator, isNull);
      expect(engine.pendingOperator, isNull);

      engine.inputDigit('4');
      engine.inputOperator('+');
      engine.inputDigit('5');
      engine.inputEquals();
      expect(engine.displayValue, '9');
    });
  });
}
