import 'package:go_router/go_router.dart';
import 'package:task_craft/core/service/local/app_state.dart';
import 'package:task_craft/module/auth/screens/login_screen.dart';
import 'package:task_craft/module/auth/screens/verify_otp_screen.dart';

/// auth router
final authRouter = [
  GoRoute(
    path: '/auth',
    redirect: (context, state) async {
      final isLoggedIn = await AppStateService().isLoggedIn();
      if (isLoggedIn == true) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: 'verify-otp',
        builder: (context, state) => const VerifyOtpScreen(),
      ),
    ],
  ),
];
