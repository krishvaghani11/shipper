import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/app_colors.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _loading = false;

  // ================= LOCATION PERMISSION =================
  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Even if denied forever, we continue (UX first)
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        debugPrint("Location permission denied");
      } else {
        // Optional: fetch location (not required now)
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
      }
    } catch (e) {
      debugPrint("Location error: $e");
    }

    if (!mounted) return;

    setState(() => _loading = false);

    // ✅ ALWAYS GO TO REGISTRATION
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.shipperRegistration,
      (_) => false,
    );
  }

  void _skipForNow() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.shipperRegistration,
      (_) => false,
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 ILLUSTRATION
              Image.asset(
                "lib/assets/images/location.png", // 👈 ensure asset path
                height: 240,
              ),

              const SizedBox(height: 30),

              // 🔹 TITLE
              const Text(
                "Enable Your",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 14),

              // 🔹 SUBTEXT
              const Text(
                "To search for the best nearby trucker\nwe want to know your current location",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 32),

              // 🔹 USE LOCATION BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _useCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Use current location",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 14),

              // 🔹 SKIP BUTTON
              TextButton(
                onPressed: _skipForNow,
                child: const Text(
                  "Skip for now",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
