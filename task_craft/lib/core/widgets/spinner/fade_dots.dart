import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:task_craft/core/widgets/spinner/tween/delay.dart';

class FadingFourSpinner extends StatefulWidget {
  const FadingFourSpinner({
    super.key,
    this.color,
    this.shape = BoxShape.circle,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  }) : assert(
          !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
              !(itemBuilder == null && color == null),
          'You should specify either a itemBuilder or a color',
        );

  final Color? color;
  final BoxShape shape;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<FadingFourSpinner> createState() => _FadingFourSpinnerState();
}

class _FadingFourSpinnerState extends State<FadingFourSpinner>
    with TickerProviderStateMixin {
  static const List<double> _delays = [.0, -0.9, -0.6, -0.3];
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();

    _controller2 = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: const Interval(0.0, 1.0),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
      _controller2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..rotateZ((_animation.value) * math.pi * 2),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: Stack(
            children: List.generate(4, (i) {
              final position = widget.size * .5;
              return Positioned.fill(
                left: position,
                top: position,
                child: Transform(
                  transform: Matrix4.rotationZ(30.0 * (i * 3) * 0.0174533),
                  child: Align(
                    child: FadeTransition(
                      opacity: DelayTween(
                        begin: 0.0,
                        end: 1.0,
                        delay: _delays[i],
                      ).animate(_controller),
                      child: SizedBox.fromSize(
                        size: Size.square(widget.size * 0.25),
                        child: _itemBuilder(i),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration: BoxDecoration(color: widget.color, shape: widget.shape),
        );
}
