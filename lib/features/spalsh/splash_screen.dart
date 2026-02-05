import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 9), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Logo at Top Right (as requested: "right side is logo")
          Positioned(
            top: 50,
            right: 20,
            child: Image.asset(
              "lib/assets/logo/logo.jpeg",
              width: 80, // Smaller logo size for top corner
            ),
          ),

          // 2. Center Illustration
          // Using a large Icon as placeholder for the "Delivery Man/Truck" illustration
          // since we verify functionality first. Can be swapped for Image later.
          Positioned(
            top: size.height * 0.2, // Positioned in the upper-middle area
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Placeholder illustration matching the 'Shipper' theme
                // If real asset exists, replace Icon with Image.asset(...)
                Image.asset(
                  "lib/assets/logo/am.png", // Reusing logo as placeholder if no other image
                  height: 180,
                ),
              ],
            ),
          ),

          // 3. Bottom Curved Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _BottomCurveClipper(),
              child: Container(
                height: size.height * 0.45, // Occupy bottom ~45% of screen
                color: AppColors.secondary, // Teal #268999
                padding: const EdgeInsets.fromLTRB(
                  24,
                  60,
                  24,
                  20,
                ), // Top padding accounts for curve
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeaturePoint("Book Trucks Online. Move Freight Faster."),
                    SizedBox(height: 16),
                    _FeaturePoint(
                      "Pan-India Network. One Platform.",
                      icon: Icons.public,
                    ),
                    SizedBox(height: 16),
                    _FeaturePoint(
                      "Verified Drivers. Safe & Reliable Deliveries.",
                      icon: Icons.verified_user,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePoint extends StatelessWidget {
  final String text;
  final IconData icon;

  const _FeaturePoint(this.text, {this.icon = Icons.check_box});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white, // White icon for better contrast on Teal
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white, // White text for better contrast on Teal
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for the convex curve at the top of the bottom section
class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Start at bottom left
    path.lineTo(0, 0);

    // However, we want the curve at the TOP.
    // So 0,0 is top-left of the container? No.
    // Let's trace from Top-Left (with offset) to Top-Right.

    // Start slightly lower on the left edge
    path.moveTo(0, 50);

    // Quadratic bezier to Top-Right (convex)
    // Control point at (width/2, 0) -> Peak of curve at top center
    // End point at (width, 50) -> Symmetrical
    path.quadraticBezierTo(size.width / 2, -20, size.width, 50);

    // Continue to bottom right
    path.lineTo(size.width, size.height);
    // To bottom left
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
