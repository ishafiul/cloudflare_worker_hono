import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_craft/core/presentation/page_not_found.dart';
import 'package:task_craft/core/service/local/app_state.dart';
import 'package:task_craft/module/auth/presentation/auth_router.dart';
import 'package:task_craft/module/home/presentation/home_screen.dart';
import 'package:task_craft/module/menu/presentation/menu_screen.dart';
import 'package:task_craft/module/todo/presentation/todo_router.dart';

/// it will return [GoRouter] object,
/// that can be use for navigation between pages
GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  errorBuilder: (context, state) {
    return const PageNotFound();
  },
  initialLocation: '/',
  redirect: (context, state) async {
    final isLoggedIn = await AppStateService().isLoggedIn();
    if (isLoggedIn == false &&
        (state.uri == Uri(path: '/auth/login') ||
            state.uri == Uri(path: '/auth/verify-otp'))) {
      return null;
    }
    if (isLoggedIn == true &&
        (state.uri == Uri(path: '/auth/login') ||
            state.uri == Uri(path: '/auth/verify-otp'))) {
      return '/';
    }
   /* if (isLoggedIn != true) {
      return '/auth/login';
    }*/
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        ...todoRouter,
        GoRoute(
          path: 'menu',
          name: 'menu',
          builder: (context, state) => const MenuScreen(),
          routes: [],
        ),
      ],
    ),

    /// auth
    ...authRouter,
  ],
);

/// page animation builder
class PageAnimation extends CustomTransitionPage {
  /// [PageAnimation] will expect a [LocalKey] and a widget as a child
  ///
  ///
  /// it will create a page animation between route change.
  /// default value is [SlideTransition] with [Offset] `1` and `0`.
  /// most of the time it will use with `go_router` `pageBuilder`.
  /// but can be used with any kind of page builder
  PageAnimation({
    required LocalKey key,
    required super.child,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
