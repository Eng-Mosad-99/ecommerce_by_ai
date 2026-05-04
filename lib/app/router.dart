import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/service_locator.dart';
import '../features/auth/auth.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String resetPassword = '/reset-password';
  static const String home = '/';

  static final router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: verifyCode,
        builder: (context, state) => const VerifyCodeView(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home - Not Implemented'))),
      ),
    ],
  );
}
