import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A hook for obtaining a [DraggableScrollableController].
///
/// Example usage:
/// ```dart
/// DraggableScrollableController controller = useDraggableScrollableController();
/// ```
DraggableScrollableController useDraggableScrollableController() {
  return use(const _DraggableScrollableControllerHook());
}

/// Hook implementation for [_DraggableScrollableControllerHook].
class _DraggableScrollableControllerHook
    extends Hook<DraggableScrollableController> {
  const _DraggableScrollableControllerHook();

  @override
  __DraggableScrollableControllerHookState createState() =>
      __DraggableScrollableControllerHookState();
}

/// State class for [_DraggableScrollableControllerHook].
class __DraggableScrollableControllerHookState extends HookState<
    DraggableScrollableController, _DraggableScrollableControllerHook> {
  DraggableScrollableController? draggableScrollableController;

  @override
  void initHook() {
    super.initHook();
    draggableScrollableController = DraggableScrollableController();
  }

  @override
  DraggableScrollableController build(BuildContext context) {
    return draggableScrollableController!;
  }

  @override
  void dispose() {
    draggableScrollableController!.dispose();
    super.dispose();
  }
}
