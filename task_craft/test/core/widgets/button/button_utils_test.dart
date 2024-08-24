import 'package:flutter/material.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/widgets/button/enums.dart';
import 'package:task_craft/core/widgets/button/utils.dart';
import 'package:test/test.dart';

void main() {
  group('buttonConstants', () {
    test('returns correct BoxConstraints for large button', () {
      final constraints = buttonConstants(buttonSize: ButtonSize.large);

      expect(constraints.minWidth, 87);
      expect(constraints.minHeight, 49);
      expect(constraints.maxHeight, 49);
    });

    test('returns correct BoxConstraints for middle button', () {
      final constraints = buttonConstants(isBlock: true);

      expect(constraints.minWidth, double.infinity);
      expect(constraints.minHeight, 40);
      expect(constraints.maxHeight, 40);
    });

    test('returns correct BoxConstraints for mini button', () {
      final constraints = buttonConstants(buttonSize: ButtonSize.mini);

      expect(constraints.minWidth, 66);
      expect(constraints.minHeight, 26);
      expect(constraints.maxHeight, 26);
    });

    test('returns correct BoxConstraints for small button', () {
      final constraints =
          buttonConstants(buttonSize: ButtonSize.small, isBlock: true);

      expect(constraints.minWidth, double.infinity);
      expect(constraints.minHeight, 29);
      expect(constraints.maxHeight, 29);
    });
  });

  group('buttonPadding', () {
    test('returns correct EdgeInsets for large button', () {
      final padding = buttonPadding(buttonSize: ButtonSize.large);

      expect(padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 12));
    });

    test('returns correct EdgeInsets for middle button', () {
      final padding = buttonPadding();

      expect(padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 8));
    });

    test('returns correct EdgeInsets for mini button', () {
      final padding = buttonPadding(buttonSize: ButtonSize.mini);

      expect(padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 4));
    });

    test('returns correct EdgeInsets for small button', () {
      final padding = buttonPadding(buttonSize: ButtonSize.small);

      expect(padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 4));
    });
  });

  group('buttonShape', () {
    test('returns RoundedRectangleBorder with base shape', () {
      final shape = buttonShape();

      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(4),
      );
    });

    test('returns RoundedRectangleBorder with rounded shape', () {
      final shape = buttonShape(shape: ButtonShape.rounded);

      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(1000),
      );
    });

    test('returns RoundedRectangleBorder with rectangular shape', () {
      final shape = buttonShape(shape: ButtonShape.rectangular);

      expect(shape, isA<RoundedRectangleBorder>());
      expect((shape as RoundedRectangleBorder).borderRadius, BorderRadius.zero);
    });
  });

  group('buttonColor', () {
    test('returns correct color for base button type', () {
      final color = buttonColor();
      expect(color, equals(CColor.border));
    });

    test('returns correct color for primary button type', () {
      final color = buttonColor(buttonType: ButtonType.primary);
      expect(color, equals(CColor.primary));
    });

    test('returns correct color for success button type', () {
      final color = buttonColor(buttonType: ButtonType.success);
      expect(color, equals(CColor.success));
    });

    test('returns correct color for warning button type', () {
      final color = buttonColor(buttonType: ButtonType.warning);
      expect(color, equals(CColor.warning));
    });

    test('returns correct color for danger button type', () {
      final color = buttonColor(buttonType: ButtonType.danger);
      expect(color, equals(CColor.danger));
    });
  });

  group('buttonTextStyle', () {
    test('returns correct TextStyle for large base button', () {
      final textStyle = buttonTextStyle(buttonSize: ButtonSize.large);

      expect(textStyle.fontSize, 18);
      expect(textStyle.color, CColor.text);
      expect(textStyle.fontWeight, FontWeight.w400);
    });

    test('returns correct TextStyle for middle primary button', () {
      final textStyle = buttonTextStyle(buttonType: ButtonType.primary);

      expect(textStyle.fontSize, 17);
      expect(textStyle.color, Colors.white);
      expect(textStyle.fontWeight, FontWeight.w400);
    });

    test('returns correct TextStyle for large base button', () {
      final textStyle = buttonTextStyle(buttonSize: ButtonSize.large);

      expect(textStyle.fontSize, 18);
      expect(textStyle.color, isA<MaterialColor>());
      expect(textStyle.fontWeight, FontWeight.w400);
      // Add more assertions based on your specific requirements
    });

    test('returns correct TextStyle for small warning button with outline fill',
        () {
      final textStyle = buttonTextStyle(
        buttonType: ButtonType.warning,
        buttonSize: ButtonSize.small,
        fill: ButtonFill.outline,
      );

      expect(textStyle.fontSize, 15);
      expect(textStyle.color, CColor.warning);
      expect(textStyle.fontWeight, FontWeight.w400);
    });
  });
}
