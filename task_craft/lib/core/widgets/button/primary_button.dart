import 'package:flutter/material.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/widgets/button/enums.dart';

import 'package:task_craft/core/widgets/button/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.fill = ButtonFill.solid,
    this.onPressed,
    this.shape = ButtonShape.base,
    this.buttonSize = ButtonSize.middle,
    this.isBlock = false,
    required this.child,
  });

  final ButtonFill? fill;
  final ButtonShape? shape;
  final ButtonSize? buttonSize;
  final void Function()? onPressed;
  final bool isBlock;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed != null ? 1 : 0.4,
      child: RawMaterialButton(
        shape: buttonShape(
          shape: shape ?? ButtonShape.base,
          fill: fill,
          buttonType: ButtonType.primary,
        ),
        textStyle: buttonTextStyle(
          fill: fill,
          buttonSize: buttonSize ?? ButtonSize.middle,
          buttonType: ButtonType.primary,
        ),
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        splashColor: CColor.primary.shade50.withOpacity(0.4),
        fillColor:
            fill == ButtonFill.solid ? CColor.primary : Colors.transparent,
        constraints: buttonConstants(
          buttonSize: buttonSize ?? ButtonSize.middle,
          isBlock: isBlock,
        ),
        padding: buttonPadding(
          buttonSize: buttonSize ?? ButtonSize.middle,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
