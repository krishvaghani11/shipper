import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/app_routes.dart';
import 'otp_popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isAccepted = false;

  void _onConfirm() {
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (phone.length != 10) {
      _showSnack("Enter valid 10 digit mobile number");
      return;
    }

    if (email.isEmpty || !email.contains("@")) {
      _showSnack("Enter valid email address");
      return;
    }

    if (!isAccepted) {
      _showSnack("Please accept privacy and policy");
      return;
    }

    // ✅ SHOW OTP POPUP
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const OtpPopup(),
    );

  }


  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // LOGO
              SvgPicture.asset(
                "lib/assets/logo/Apexcel (1).svg",
                height: 100,
              ),

              const SizedBox(height: 20),

              const Text(
                "Trusted by 1 lakh + Businesses, SMEs & Transporters Across India",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 30),

              // PHONE FIELD
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  prefixIcon: Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("🇮🇳", style: TextStyle(fontSize: 18)),
                        SizedBox(width: 6),
                        Text("+91",
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  hintText: "Mobile Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // EMAIL FIELD
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Email Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // CHECKBOX
              Row(
                children: [
                  Checkbox(
                    value: isAccepted,
                    activeColor: Colors.orange,
                    onChanged: (v) {
                      setState(() {
                        isAccepted = v ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "I have accepted privacy and policy",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // CONFIRM BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

