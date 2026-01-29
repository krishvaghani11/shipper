import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'routes/app_routes.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const ShipperApp(),
    ),
  );
}

class ShipperApp extends StatelessWidget {
  const ShipperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,

      // ✅ ROUTE BASED APP
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}



