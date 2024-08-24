import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/app/view/app.dart';
import 'package:task_craft/core/config/colors.dart';
import 'package:task_craft/core/config/custom_icons_icons.dart';
import 'package:vibration/vibration.dart';

/// Enum representing different types of SnackBars.
///
/// Use this enum to specify the desired visual style and behavior when displaying SnackBars.
enum SnackBarType {
  /// Indicates a warning-related SnackBar.
  base,

  /// Indicates a success-related SnackBar.
  alert,

  /// Indicates a danger-related SnackBar.
  error,

  /// Indicates an information-related SnackBar.
  info,
}

/// Displays a snack bar with various configurations based on the provided parameters.
///
/// Parameters:
/// - `builderContext`: The build context in which the snack bar should be displayed.
/// - `onPressed`: A callback function to be executed when the snack bar action is pressed.
/// - `type`: The type of the snack bar (error, success, danger, info, warning).
/// - `message`: The main message to be displayed in the snack bar.
/// - `title`: The title of the snack bar.
/// - `leadingIcon`: The icon displayed at the beginning of the snack bar.
/// - `tailingIcon`: The icon displayed at the end of the snack bar.
Future<void> showSnackBar({
  BuildContext? builderContext,
  SnackBarType? type = SnackBarType.base,
  bool? closable = true,
  bool? withIcon = false,
  IconData? leadingIcon,
  required String message,
}) async {
  await Vibration.vibrate(
    duration: 10,
  );

  await Vibration.vibrate(
    duration: 10,
  );
  late SnackBar snackBar;
  switch (type) {
    case SnackBarType.base:
      snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFFABABAB),
            border: Border(
              top: BorderSide(color: CColor.weak),
              bottom: BorderSide(color: CColor.weak),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withIcon == true)
                  Icon(
                    leadingIcon ?? CustomIcons.sound,
                    color: Colors.white,
                  ),
                if (withIcon == true) 8.horizontalSpace,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (closable == true) 8.horizontalSpace,
                      if (closable == true)
                        InkWell(
                          onTap: () {
                            scaffoldMessageKey.currentState
                                ?.removeCurrentSnackBar();
                          },
                          child: const Icon(
                            CustomIcons.close,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case SnackBarType.alert:
      snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF9ED),
            border: Border(
              top: BorderSide(color: Color(0xFFFFF3E9)),
              bottom: BorderSide(color: Color(0xFFFFF3E9)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withIcon == true)
                  Icon(
                    leadingIcon ?? CustomIcons.sound,
                    color: CColor.warning,
                  ),
                if (withIcon == true) 8.horizontalSpace,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: CColor.warning,
                            fontSize: 15,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (closable == true) 8.horizontalSpace,
                      if (closable == true)
                        InkWell(
                          onTap: () {
                            scaffoldMessageKey.currentState
                                ?.removeCurrentSnackBar();
                          },
                          child: Icon(
                            CustomIcons.close,
                            color: CColor.warning,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case SnackBarType.error:
      snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: CColor.danger,
            border: const Border(
              top: BorderSide(color: Color(0xFFD9281E)),
              bottom: BorderSide(color: Color(0xFFD9281E)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withIcon == true)
                  Icon(
                    leadingIcon ?? CustomIcons.sound,
                    color: Colors.white,
                  ),
                if (withIcon == true) 8.horizontalSpace,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (closable == true) 8.horizontalSpace,
                      if (closable == true)
                        InkWell(
                          onTap: () {
                            scaffoldMessageKey.currentState
                                ?.removeCurrentSnackBar();
                          },
                          child: const Icon(
                            CustomIcons.close,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case SnackBarType.info:
      snackBar = SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Color(0xffD0E4FF),
            border: Border(
              top: BorderSide(color: Color(0xFFBCD8FF)),
              bottom: BorderSide(color: Color(0xFFBCD8FF)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (withIcon == true)
                  Icon(
                    leadingIcon ?? CustomIcons.sound,
                    color: CColor.info,
                  ),
                if (withIcon == true) 8.horizontalSpace,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: CColor.info,
                            fontSize: 15,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (closable == true) 8.horizontalSpace,
                      if (closable == true)
                        InkWell(
                          onTap: () {
                            scaffoldMessageKey.currentState
                                ?.removeCurrentSnackBar();
                          },
                          child: Icon(
                            CustomIcons.close,
                            color: CColor.info,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    case null:
    // TODO: Handle this case.
  }

  // Show the SnackBar using the provided build context
  scaffoldMessageKey.currentState?.removeCurrentSnackBar();
  scaffoldMessageKey.currentState?.showSnackBar(snackBar);
}
