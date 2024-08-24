import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_craft/bootstrap.dart';
import 'package:task_craft/core/utils/extention.dart';
import 'package:task_craft/core/widgets/button/button.dart';
import 'package:task_craft/core/widgets/button/enums.dart';

/// Handles the permission specified by `permission` by checking and requesting it if necessary.
/// If the permission is denied or permanently denied, it prompts the user with a dialog
/// providing information about the permission and gives an option to open the settings.
///
/// The function returns after the user's response or if the permission is already granted.
///
/// Parameters:
/// - `context`: The BuildContext to show dialogs and navigate.
/// - `permission`: The `PermissionWithService` to be checked and requested.
/// - `builder`: A function that returns the content of the dialog.
/// - `accessName`: A String that will represent the requesting permission name
Future<bool> handlePermission({
  required BuildContext context,
  required Permission permission,
  required Widget Function(BuildContext) builder,
  String? accessName,
}) async {
  // Check if the permission is already granted
  if (await permission.isGranted) {
    return true;
  }

  // Request the permission
  try {
    final permissionStatus = await permission.request();
    if (!context.mounted) return false;
    return _handelDeniedOrPermanentlyDenied(
      context: context,
      permission: permissionStatus,
      builder: builder,
      accessName: accessName,
    );
  } catch (e) {
    logger.w("Failed to request permission: $e");
  }
  if (!context.mounted) return false;
  return _handelDeniedOrPermanentlyDenied(
    context: context,
    permission: await permission.status,
    builder: builder,
    accessName: accessName,
  );
}

Future<bool> _handelDeniedOrPermanentlyDenied({
  required BuildContext context,
  required PermissionStatus permission,
  required Widget Function(BuildContext) builder,
  String? accessName,
}) async {
  // If the permission is denied or permanently denied, show a dialog
  if (permission.isDenied || permission.isPermanentlyDenied) {
    // Check if the widget is still mounted before showing the dialog
    if (!context.mounted) return false;

    // Show the permission request dialog
    final isOpenSetting = await showRequestPermissionDialog<bool>(
      context: context,
      builder: builder,
      accessName: accessName,
    );

    // If the user chooses to open settings, navigate to app settings
    if (isOpenSetting == true) {
      await openAppSettings();
    }

    return false;
  }
  return true;
}

/// Shows a dialog requesting permission and provides options to cancel or open settings.
///
/// Parameters:
/// - `context`: The BuildContext to show the dialog.
/// - `builder`: A function that returns the content of the dialog.
///
/// Returns a Future with the user's response (true if open settings, false if cancel).
Future<T?> showRequestPermissionDialog<T>({
  required BuildContext context,
  String? accessName,
  required Widget Function(BuildContext context) builder,
}) async {
  // Show a dialog with permission request content
  final isOpenSettings = await showDialog<T>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: 20.paddingAll(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              builder(context),
              Divider(
                color: Colors.grey.shade300,
              ),
              SizedBox(
                height: 8.h,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button to open app settings
                  Button.primary(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    isBlock: true,
                    child: accessName != null
                        ? Text("Enable $accessName Access")
                        : const Text("Open Settings"),
                  ),
                  16.verticalSpace,
                  // Button to cancel the request
                  Button.primary(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    isBlock: true,
                    fill: ButtonFill.outline,
                    child: const Text("Not Now"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  // Return the user's response
  return isOpenSettings;
}
