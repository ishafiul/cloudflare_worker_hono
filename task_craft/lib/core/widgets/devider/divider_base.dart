import 'package:flutter/material.dart';
import 'package:task_craft/core/config/colors.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({
    super.key,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
    required this.axis,
  })  : assert(width == null || width >= 0.0),
        assert(thickness == null || thickness >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0);

  final double? width;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    switch (axis) {
      case Axis.horizontal:
        return Divider(
          thickness: thickness,
          indent: indent,
          height: height,
          endIndent: endIndent,
          color: CColor.border,
        );
      case Axis.vertical:
        return VerticalDivider(
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          width: width,
          color: CColor.border,
        );
    }
  }
}
