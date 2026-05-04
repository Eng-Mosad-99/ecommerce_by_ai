import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyCode = '/verify-code';
  static const String resetPassword = '/reset-password';
  static const String home = '/';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home - Not Implemented'))),
      ),
    ],
  );
}
