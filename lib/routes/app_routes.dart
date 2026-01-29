import 'package:flutter/material.dart';

import '../features/spalsh/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/bottom_nav/bottom_nav_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String bottomNav = '/bottomNav';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    bottomNav: (context) => const BottomNavScreen(),
  };
}

