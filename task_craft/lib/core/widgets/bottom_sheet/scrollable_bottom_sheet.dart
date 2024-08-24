import 'package:flutter/material.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:task_craft/core/utils/extention.dart';

class ScrollableBottomSheet extends StatelessWidget {
  const ScrollableBottomSheet({
    super.key,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    required this.child,
    this.padding,
  });

  final double? initialChildSize;

  final double? minChildSize;

  final double? maxChildSize;
  final List<Widget> child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize ?? 0.6,
          minChildSize: minChildSize ?? 0.3,
          maxChildSize: maxChildSize ?? 0.9,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: padding,
              children: [
                Container(
                  padding: 8.paddingVertical(),
                  child: const Icon(
                    CustomIcons.minus,
                    color: Color(0xffABABAB),
                  ),
                ),
                ...child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
