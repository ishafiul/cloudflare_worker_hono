import 'package:flutter/material.dart';
import 'package:task_craft/core/config/colors.dart';

enum CCardType { primary, warning, danger, success }

class CCard extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final CCardType cardType;
  final Function()? onTap;
  final Color? borderColor;
  final Color? bgColor;
  final BorderRadiusGeometry? borderRadius;

  const CCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    required this.cardType,
    this.borderColor,
    required this.child,
    this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [],
      ),
      child: Stack(
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: bgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? _color(cardType)),
              borderRadius: borderRadius ??
                  const BorderRadius.all(
                    Radius.circular(10),
                  ),
            ),
            child: SizedBox(
              width: width ?? double.infinity,
              height: height,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                onTap: onTap,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _color(CCardType type) {
    if (type == CCardType.primary) {
      return CColor.primary.shade50;
    }
    if (type == CCardType.warning) {
      return CColor.warning.shade50;
    }
    if (type == CCardType.success) {
      return CColor.success.shade50;
    } else {
      return CColor.danger.shade50;
    }
  }
}
