import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A linear loading indicator widget with customizable colors.
///
/// Example usage:
/// ```dart
/// LinearLoadingIndicator(
///   color: Colors.blue,
///   backgroundColor: Colors.grey,
/// )
/// ```
class LinearLoadingIndicator extends StatefulWidget {
  /// The color of the moving part of the loading indicator.
  final Color? color;

  /// The background color of the loading indicator.
  final Color? backgroundColor;

  /// Creates a linear loading indicator widget with customizable colors.
  const LinearLoadingIndicator({
    this.color = Colors.black,
    this.backgroundColor = Colors.grey,
  });

  @override
  _LinearLoadingIndicatorState createState() => _LinearLoadingIndicatorState();
}

/// State class for [LinearLoadingIndicator].
class _LinearLoadingIndicatorState extends State<LinearLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  /// Maximum height of the loading indicator.
  double maxHeight = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (maxHeight != constraints.maxWidth) {
              maxHeight = constraints.maxWidth;
            }
            return Container(
              height: 4.r,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(5).r,
              ),
            );
          },
        ),
        Transform.translate(
          offset: Offset(0 + ((maxHeight - 35.r) * _animation.value), 0),
          child: Container(
            width: 35.r,
            height: 4.r,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(4).r,
            ),
          ),
        ),
      ],
    );
  }
}
