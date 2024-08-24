import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_craft/core/widgets/button/button.dart';

void main() {
  group('Button Widget Tests', () {
    testWidgets('Base Button renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button(
              onPressed: () {},
              child: const Text('Base Button'),
            ),
          ),
        ),
      );

      expect(find.text('Base Button'), findsOneWidget);
      // Add more assertions based on your specific requirements
    });

    testWidgets('Primary Button renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.primary(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
          ),
        ),
      );

      expect(find.text('Primary Button'), findsOneWidget);
      // Add more assertions based on your specific requirements
    });

    testWidgets('Success Button renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.success(
              onPressed: () {},
              child: const Text('Success Button'),
            ),
          ),
        ),
      );

      expect(find.text('Success Button'), findsOneWidget);
      // Add more assertions based on your specific requirements
    });

    testWidgets('Warning Button renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.warning(
              onPressed: () {},
              child: const Text('Warning Button'),
            ),
          ),
        ),
      );

      expect(find.text('Warning Button'), findsOneWidget);
      // Add more assertions based on your specific requirements
    });

    testWidgets('Danger Button renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Button.danger(
              onPressed: () {},
              child: const Text('Danger Button'),
            ),
          ),
        ),
      );

      expect(find.text('Danger Button'), findsOneWidget);
      // Add more assertions based on your specific requirements
    });

    // Add more test cases based on different combinations of ButtonType, ButtonFill, ButtonShape, ButtonSize, and isBlock
  });
}
