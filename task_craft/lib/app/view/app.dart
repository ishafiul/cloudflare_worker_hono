import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_craft/app/app_router.dart';
import 'package:task_craft/core/config/bloc_provider.dart';
import 'package:task_craft/core/config/get_it.dart';
import 'package:task_craft/core/config/theme.dart';

/// [GlobalKey] for [ScaffoldMessenger]
GlobalKey<ScaffoldMessengerState> scaffoldMessageKey =
    GlobalKey<ScaffoldMessengerState>();

/// [App]
class App extends StatelessWidget {
  /// starting point of our app
  /// this [StatelessWidget] will hold material app with
  /// go_router, and global blog provider. also `ScreenUtil` setup is here
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getIt<Provider>().providers,
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (BuildContext context, _) {
          return MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessageKey,
            debugShowCheckedModeBanner: false,
            theme: getIt<AppTheme>().lightTheme,
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
