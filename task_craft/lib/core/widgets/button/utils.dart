import 'package:flutter/material.dart';
import 'package:task_craft/core/config/colors.dart';

import 'package:task_craft/core/widgets/button/enums.dart';

BoxConstraints buttonConstants({
  ButtonSize buttonSize = ButtonSize.middle,
  bool isBlock = false,
}) {
  switch (buttonSize) {
    case ButtonSize.large:
      return BoxConstraints(
        minWidth: isBlock ? double.infinity : 87,
        minHeight: 49,
        maxHeight: 49,
      );
    case ButtonSize.middle:
      return BoxConstraints(
        minWidth: isBlock ? double.infinity : 78,
        minHeight: 40,
        maxHeight: 40,
      );
    case ButtonSize.mini:
      return BoxConstraints(
        minWidth: isBlock ? double.infinity : 66,
        minHeight: 26,
        maxHeight: 26,
      );
    case ButtonSize.small:
      return BoxConstraints(
        minWidth: isBlock ? double.infinity : 72,
        minHeight: 29,
        maxHeight: 29,
      );
  }
}

EdgeInsetsGeometry buttonPadding({ButtonSize buttonSize = ButtonSize.middle}) {
  switch (buttonSize) {
    case ButtonSize.large:
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    case ButtonSize.middle:
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    case ButtonSize.mini:
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
    case ButtonSize.small:
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  }
}

ShapeBorder buttonShape({
  ButtonFill? fill = ButtonFill.solid,
  ButtonShape shape = ButtonShape.base,
  ButtonType buttonType = ButtonType.base,
}) {
  switch (shape) {
    case ButtonShape.base:
      return RoundedRectangleBorder(
        side: () {
          if (buttonType == ButtonType.base) {
            return BorderSide(
              color: buttonColor(buttonType: buttonType),
            );
          }
          return fill != ButtonFill.outline
              ? BorderSide.none
              : BorderSide(
                  color: buttonColor(buttonType: buttonType),
                );
        }.call(),
        borderRadius: BorderRadius.circular(4),
      );

    case ButtonShape.rounded:
      return RoundedRectangleBorder(
        side: () {
          if (buttonType == ButtonType.base) {
            return BorderSide(
              color: buttonColor(buttonType: buttonType),
            );
          }
          return fill != ButtonFill.outline
              ? BorderSide.none
              : BorderSide(
                  color: buttonColor(buttonType: buttonType),
                );
        }.call(),
        borderRadius: BorderRadius.circular(1000),
      );

    case ButtonShape.rectangular:
      return RoundedRectangleBorder(
        side: () {
          if (buttonType == ButtonType.base) {
            return BorderSide(
              color: buttonColor(buttonType: buttonType),
            );
          }
          return fill != ButtonFill.outline
              ? BorderSide.none
              : BorderSide(
                  color: buttonColor(buttonType: buttonType),
                );
        }.call(),
      );
  }
}

Color buttonColor({
  ButtonType buttonType = ButtonType.base,
}) {
  switch (buttonType) {
    case ButtonType.base:
      return CColor.border;
    case ButtonType.primary:
      return CColor.primary;
    case ButtonType.success:
      return CColor.success;
    case ButtonType.warning:
      return CColor.warning;
    case ButtonType.danger:
      return CColor.danger;
  }
}

/// [TextStyle] based on [ButtonSize] and [ButtonType]
TextStyle buttonTextStyle({
  ButtonType buttonType = ButtonType.base,
  ButtonSize buttonSize = ButtonSize.middle,
  ButtonFill? fill = ButtonFill.solid,
}) {
  print(buttonType);
  final textColor = buttonType == ButtonType.base
      ? CColor.text
      : fill == ButtonFill.solid
          ? Colors.white
          : buttonColor(buttonType: buttonType);
  switch (buttonSize) {
    case ButtonSize.large:
      return TextStyle(
        fontSize: 18,
        color: textColor,
        fontFamily: 'Arial',
        fontWeight: FontWeight.w400,
      );
    case ButtonSize.middle:
      return TextStyle(
        fontSize: 17,
        color: textColor,
        fontFamily: 'Arial',
        fontWeight: FontWeight.w400,
      );
    case ButtonSize.mini:
      return TextStyle(
        fontSize: 13,
        color: textColor,
        fontFamily: 'Arial',
        fontWeight: FontWeight.w400,
      );
    case ButtonSize.small:
      return TextStyle(
        fontSize: 15,
        color: textColor,
        fontFamily: 'Arial',
        fontWeight: FontWeight.w400,
      );
  }
}
