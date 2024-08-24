import 'package:flutter/material.dart';
import 'package:task_craft/core/widgets/devider/divider_base.dart';

enum TextDividerPosition {
  left,
  right,
  center,
}

class TextDivider extends StatelessWidget {
  const TextDivider(
      {required this.text, this.position = TextDividerPosition.center});

  final String text;

  final TextDividerPosition? position;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: position == TextDividerPosition.right ? 7 : 1,
          child: const BaseDivider(axis: Axis.horizontal),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
              fontFamily: 'Arial',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Flexible(
          flex: position == TextDividerPosition.left ? 7 : 1,
          child: const BaseDivider(axis: Axis.horizontal),
        ),
      ],
    );
  }
}
