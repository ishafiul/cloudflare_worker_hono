import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:task_craft/app/app.dart';
import 'package:task_craft/core/snackbar/cubit/snack_bar_cubit.dart';
import 'package:task_craft/module/auth/cubit/logout/logout_cubit.dart';
import 'package:task_craft/module/auth/cubit/request_otp/request_otp_cubit.dart';
import 'package:task_craft/module/auth/cubit/verify_otp/verify_otp_cubit.dart';
import 'package:task_craft/module/todo/cubit/get_todos/get_todos_cubit.dart';
import 'package:task_craft/module/user/domain/cubit/user_me/user_me_cubit.dart';

/// [Provider] is a [Singleton] that will provide [List] of [BlocProvider].
/// need to provide [BlocProvider] for those `bloc` or `cubit` that will be available
/// throw out the application. inside [App] widget we wrapped our [MaterialApp]
/// with [MultiBlocProvider] and we are passing those bloc providers.
@Singleton()
class Provider {
  /// [List] of [BlocProvider]
  List<BlocProvider> providers = [
    BlocProvider<SnackBarCubit>(
      create: (BuildContext context) => SnackBarCubit(),
    ),
    BlocProvider<RequestOtpCubit>(
      create: (BuildContext context) => RequestOtpCubit(),
    ),
    BlocProvider<VerifyOtpCubit>(
      create: (BuildContext context) => VerifyOtpCubit(),
    ),
    BlocProvider<LogoutCubit>(
      create: (BuildContext context) => LogoutCubit(),
    ),
    BlocProvider<UserMeCubit>(
      create: (BuildContext context) => UserMeCubit(),
    ),
    BlocProvider<GetTodosCubit>(
      create: (BuildContext context) => GetTodosCubit(),
    ),
    BlocProvider<UpdateTodoCubit>(
      create: (BuildContext context) => UpdateTodoCubit(),
    ),

    /*BlocProvider<GoogleAuthCubit>(
      create: (BuildContext context) => GoogleAuthCubit(AuthRepository()),
    ),
    BlocProvider<LogoutCubit>(
      create: (BuildContext context) =>
          LogoutCubit(repository: AuthRepository()),
    ),
    BlocProvider<UserMeCubit>(
      create: (BuildContext context) =>
          UserMeCubit(userRepository: UserRepository()),
    ),*/
  ];
}
