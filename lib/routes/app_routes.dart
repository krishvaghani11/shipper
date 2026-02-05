import 'package:flutter/material.dart';

import '../features/spalsh/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/location/location_screen.dart';
import '../features/bottom_nav/bottom_nav_screen.dart';
import '../features/registration/shipper_registration_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp'; // ✅ ADDED
  static const String bottomNav = '/bottomNav';
  static const String dashboardScreen = '/dashboard'; // ✅ ADDED
  static const String locationScreen = '/location';
  static const String shipperRegistration = '/shipper-registration';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    otp: (context) => const OtpScreen(), // ✅ ADDED
    bottomNav: (context) => const BottomNavScreen(),
    dashboardScreen: (context) => const DashboardScreen(), // ✅ ADDED
    locationScreen: (context) => const LocationScreen(),
    shipperRegistration: (context) => const ShipperRegistrationScreen(),
  };
}
