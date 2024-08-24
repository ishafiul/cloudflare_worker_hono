import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/mesure_widget.dart';

enum SnapBottomSheetInitialState {
  minimized,
  maximized,
}

/// A widget representing the rejected Vangti request UI.
/// A widget representing the rejected Vangti request UI.
class SnapBottomSheet extends StatefulWidget {
  /// Creates a [SnapBottomSheet] widget.
  const SnapBottomSheet({
    super.key,
    required this.minChild,
    required this.maxChild,
    required this.body,
    this.backgroundColor = Colors.white,
    this.initialState = SnapBottomSheetInitialState.minimized,
  });

  /// The widget to be displayed when the sheet is minimized.
  final Widget minChild;

  /// The initial state of the bottom sheet.
  final SnapBottomSheetInitialState initialState;

  final Color backgroundColor;

  /// The widget to be displayed when the sheet is maximized.
  final Widget maxChild;

  /// The title of the bottom sheet.
  final Widget body;

  @override
  State<SnapBottomSheet> createState() => _SnapBottomSheetState();
}

class _SnapBottomSheetState extends State<SnapBottomSheet> {
  double minHeight = 0.0;
  double maxHeight = 0.0;
  double position = 0.0;
  double onlyMinChildHeight = 0.0;

  @override
  void didUpdateWidget(covariant SnapBottomSheet oldWidget) {
    if (oldWidget.minChild != widget.minChild &&
        oldWidget.maxChild != widget.maxChild) {}
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SlidingUpPanel(
        onPanelSlide: (position) {
          if (position > 0) {}
          setState(() {
            this.position = position;
          });
        },

        panel: MeasureSize(
          onChange: (size) {
            maxHeight = size.height;
            setState(() {
              print("called");
              print(maxHeight);
            });
          },
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (position == 0)
                  (minHeight + 4).verticalSpace
                else
                  (minHeight - onlyMinChildHeight).verticalSpace,
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: widget.maxChild,
                ),
              ],
            ),
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        snapPoint: 0.5,
        boxShadow: position == 1
            ? []
            : [
                const BoxShadow(
                  color: Color(0x19668386),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
        header: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: MeasureSize(
            onChange: (size) {
              minHeight = size.height;
              setState(() {});
            },
            child: Column(
              children: [
                Container(
                  padding: 8.paddingVertical(),
                  child: const Icon(
                    CustomIcons.minus,
                    color: Color(0xffABABAB),
                  ),
                ),
                if (position == 0)
                  MeasureSize(
                    onChange: (Size size) {
                      onlyMinChildHeight = size.height;
                      setState(() {});
                    },
                    child: widget.minChild,
                  ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
        minHeight: minHeight,
        maxHeight: MediaQuery.sizeOf(context).height - (56),
        // 56 is safe area top height
        body: widget.body,
      ),
    );
  }
}
