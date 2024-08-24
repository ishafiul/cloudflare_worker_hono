import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    required this.isLoading,
    this.borderRadius,
    this.child,
    this.height,
    this.width,
  });

  final bool isLoading;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final double? height;
  final double? width;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with TickerProviderStateMixin {
  bool _isLoading = true;

  @override
  void initState() {
    _isLoading = widget.isLoading;
    setState(() {});
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppShimmer oldWidget) {
    if (widget == oldWidget) return;
    _isLoading = widget.isLoading;
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _isLoading,
          maintainAnimation: true,
          maintainState: true,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeIn,
            opacity: _isLoading ? 1 : 0,
            child: widget.child ?? Container(),
          ),
        ),
        Visibility(
          visible: !_isLoading,
          maintainAnimation: true,
          maintainState: true,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 30),
            curve: Curves.easeOut,
            opacity: !_isLoading ? 1 : 0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: widget.height ?? 42,
                width: widget.width ?? double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
