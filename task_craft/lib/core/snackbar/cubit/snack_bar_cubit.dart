import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:task_craft/core/widgets/snackbar.dart';

part 'snack_bar_state.dart';

///snacbar cubit that can trigger snackbar from any where in this application
@Singleton()
class SnackBarCubit extends Cubit<SnackBarState> {
  ///snacbar cubit that can trigger snackbar from any where in this application
  SnackBarCubit() : super(SnackBarInitial());

  /// show snackbar method
  Future<void> snackBar({
    Function? onPressed,
    required SnackBarType type,
    required String message,
    required String title,
  }) async {
    emit(
      SnackBarLoaded(
        type: type,
        message: message,
        onPressed: onPressed,
        title: title,
      ),
    );
    emit(SnackBarInitial());
  }
}
