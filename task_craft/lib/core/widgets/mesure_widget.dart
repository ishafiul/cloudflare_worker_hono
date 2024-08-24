import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Callback function type for widget size change events.
typedef OnWidgetSizeChange = void Function(Size size);

/// A custom render object for measuring the size of a child widget.
class MeasureSizeRenderObject extends RenderProxyBox {
  /// The previously measured size of the child widget.
  Size? oldSize;

  /// Callback function triggered on widget size change.
  OnWidgetSizeChange onChange;

  /// Creates an instance of [MeasureSizeRenderObject] with the specified [onChange] callback.
  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    final Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

/// A widget that measures and notifies about changes in the size of its child.
class MeasureSize extends SingleChildRenderObjectWidget {
  /// Callback function triggered on widget size change.
  final OnWidgetSizeChange onChange;

  /// Creates an instance of [MeasureSize] with the specified [onChange] callback and [child].
  const MeasureSize({
    super.key,
    required this.onChange,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}
