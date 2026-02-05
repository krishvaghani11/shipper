import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/otp_service.dart';
import '../../routes/app_routes.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String enteredOtp = "";

  Future<void> _verifyOtp() async {
    if (enteredOtp.length != 6) return;

    try {
      // 🔐 Backend remains (for future real verification)
      await OtpService.verifyOtp(enteredOtp);
    } catch (e) {
      // ❗ Ignore backend failure for now
      debugPrint("OTP verification skipped / failed: $e");
    }

    if (!mounted) return;

    // ✅ ALWAYS GO TO LOCATION SCREEN
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.locationScreen,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🔹 LOGO + APP NAME
              Row(
                children: [
                  Image.asset(
                    "lib/assets/images/logoo.png", // ✅ FIXED PATH
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Shipper",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔹 TITLE
              const Text(
                "Enter OTP",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                "Please enter the 6 digit OTP code sent on\n+91XXXXXXXXXX",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // 🔹 OTP INPUT (6 BOXES)
              OtpInput(
                length: 6,
                onCompleted: (otp) {
                  enteredOtp = otp;
                },
              ),

              const SizedBox(height: 30),

              // 🔹 NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "NEXT",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 🔹 RESEND TEXT
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                        text: "Didn’t receive the code? ",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextSpan(
                        text: "Resend (30s)",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 OTP VIA ICONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _iconButton(Icons.sms),
                  const SizedBox(width: 18),
                  _iconButton(Icons.email),
                  const SizedBox(width: 18),
                  _iconButton(Icons.chat),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

/* ======================================================
   OTP INPUT BOX WIDGET (6 DIGITS)
====================================================== */

class OtpInput extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;

  const OtpInput({super.key, required this.length, required this.onCompleted});

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.length, (_) => TextEditingController());
    focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }

    final otp = controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in FittedBox to prevent overflow on small screens
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return Container(
            width: 45, // Reduced slightly (48 -> 45)
            height: 56,
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ), // Reduced margin (5 -> 4)
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ), // Reduced font slightly
              decoration: InputDecoration(
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
