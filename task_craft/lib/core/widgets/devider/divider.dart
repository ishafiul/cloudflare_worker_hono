import 'package:flutter/material.dart';
import 'package:task_craft/core/widgets/devider/divider_base.dart';
import 'package:task_craft/core/widgets/devider/text_divider.dart';

enum DeviderType { text, base }

class CDivider extends StatelessWidget {
  CDivider.base({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
    required this.axis,
  }) {
    deviderType = DeviderType.base;
  }

  CDivider.text({
    super.key,
    required this.text,
    this.position = TextDividerPosition.center,
  }) {
    deviderType = DeviderType.text;
  }

  late final double? width;
  late final double? height;
  late final double? thickness;
  late final double? indent;
  late final double? endIndent;
  late final String? text;
  late final Axis? axis;
  late final DeviderType? deviderType;
  late final TextDividerPosition? position;

  @override
  Widget build(BuildContext context) {
    switch (deviderType!) {
      case DeviderType.text:
        return TextDivider(
          text: text!,
          position: position,
        );
      case DeviderType.base:
        return BaseDivider(
          axis: axis!,
          width: width,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          height: height,
        );
    }
  }
}
