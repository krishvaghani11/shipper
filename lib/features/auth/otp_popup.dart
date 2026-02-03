import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../core/services/otp_service.dart';

class OtpPopup extends StatelessWidget {
  const OtpPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

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
              controller: otpController, // ✅ ADDED
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

            // ICONS (EMAIL OTP SEND LOGIC ADDED)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.sms, color: Colors.grey),

                GestureDetector(
                  onTap: () async {
                    try {
                      await OtpService.sendEmailOtp(OtpService.userEmail!);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("OTP sent successfully to your email"),
                        ),
                      );
                    } catch (e) {
                      debugPrint("SEND OTP ERROR: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to send OTP"),
                        ),
                      );
                    }
                  },

                  child: const Icon(Icons.email, color: Colors.orange),
                ),

                const Icon(Icons.chat, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
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
                    onPressed: () async {
                      try {
                        // ✅ STEP 10B: VERIFY OTP
                        await OtpService.verifyOtp(
                          OtpService.userEmail!,
                          otpController.text.trim(),
                        );

                        // ✅ SUCCESS → REGISTRATION SCREEN
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.shipperRegistration,
                              (route) => false,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid OTP"),
                          ),
                        );
                      }
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
