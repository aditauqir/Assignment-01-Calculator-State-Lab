import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/main.dart';

void main() {
  testWidgets('Calculator UI renders and performs 2 + 3 × 4 = 20', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    // Verify initial screen state has '0'
    expect(find.text('0'), findsWidgets);
    expect(find.text('Calculator'), findsOneWidget);

    // Tap '2'
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    // Tap '+'
    await tester.tap(find.text('+'));
    await tester.pumpAndSettle();

    // Tap '3'
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    // Tap '×' (should compute 2 + 3 = 5 as running total)
    await tester.tap(find.text('×'));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsWidgets);

    // Tap '4'
    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();

    // Tap '=' (should compute 5 × 4 = 20)
    await tester.tap(find.text('='));
    await tester.pumpAndSettle();
    expect(find.text('20'), findsWidgets);
  });

  testWidgets('Calculator Clear / All Clear resets display', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    // Type 9
    await tester.tap(find.text('9'));
    await tester.pumpAndSettle();
    expect(find.text('9'), findsWidgets);

    // Clear Entry 'C'
    await tester.tap(find.text('C'));
    await tester.pumpAndSettle();

    // Display resets to 0
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('Theme toggle switches between dark and light palettes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      const Color(0xFF000000),
    );
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      const Color(0xFFFFF6FB),
    );
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
  });

  testWidgets('Calculator controls expose meaningful semantic labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Digit 2'), findsOneWidget);
    expect(find.bySemanticsLabel('Plus'), findsOneWidget);
    expect(find.bySemanticsLabel('All clear'), findsOneWidget);
    expect(find.bySemanticsLabel('Switch to light mode'), findsOneWidget);

    await tester.tap(find.text('9'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Clear entry'), findsOneWidget);
  });

  testWidgets('Calculator buttons expose the tactile scale animation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    expect(find.byType(AnimatedScale), findsNWidgets(20));

    final buttonScale = tester.widget<AnimatedScale>(
      find
          .ancestor(of: find.text('2'), matching: find.byType(AnimatedScale))
          .first,
    );
    expect(buttonScale.scale, 1.0);
    expect(buttonScale.duration, const Duration(milliseconds: 70));
    expect(buttonScale.curve, Curves.easeOutCubic);
  });
}
