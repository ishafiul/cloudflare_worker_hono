part of 'snack_bar_cubit.dart';

/// snackbar state
@immutable
abstract class SnackBarState {}

/// initial snackbar state
class SnackBarInitial extends SnackBarState {}

/// when snackbar loaded

class SnackBarLoaded extends SnackBarState {
  /// callback method  that will trigger when close button press
  final Function? onPressed;

  /// [SnackBarType]
  final SnackBarType type;

  /// message for snackbar
  final String message;
  final String title;
  final IconData? leadingIcon;
  final IconData? tailingIcon;

  SnackBarLoaded({
    required this.title,
    this.onPressed,
    required this.type,
    required this.message,
    this.leadingIcon,
    this.tailingIcon,
  });
}
