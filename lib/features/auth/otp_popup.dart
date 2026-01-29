import 'package:flutter/material.dart';
import '../../routes/app_routes.dart'; // ✅ ADD THIS IMPORT

class OtpPopup extends StatelessWidget {
  const OtpPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // OTP FIELD
            TextField(
              maxLength: 6,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 20,
                letterSpacing: 6,
              ),
              decoration: InputDecoration(
                counterText: "",
                hintText: "------",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ICONS (UI ONLY)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.sms, color: Colors.grey),
                Icon(Icons.email, color: Colors.orange),
                Icon(Icons.chat, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // ✅ JUST CLOSE OTP (BACK TO LOGIN)
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // ✅ OTP VERIFIED → DASHBOARD + BOTTOM NAV
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.bottomNav,
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


