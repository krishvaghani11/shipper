import 'package:flutter/material.dart';
import 'otp_popup.dart';
import '../../core/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  // Note: Email field removed as per design 'Design 1'.
  // final TextEditingController emailController = TextEditingController();

  bool isAccepted = false;
  // isLoading moved to Popup later, but if we need it here for any preliminary checks, we keep it.
  // Although purely UI navigation to popup doesn't need loading.

  void _onNext() {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _showSnack("Enter valid 10 digit mobile number");
      return;
    }

    if (!isAccepted) {
      _showSnack("Please accept Terms & Privacy Policy");
      return;
    }

    // Directly show popup without API call here. API call happens in Popup.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OtpPopup(phoneNumber: "+91 $phone"),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // 🔹 ILLUSTRATION
              // Using the provided 'lib/assets/logo/logo.jpeg' or previous 'am.png' as placeholder
              // since I don't have the specific 'Delivery Man' vector from Figma unless it's 'am.png'.
              // The user replaced 'am.png' with 'logo.jpeg' in splash. I will use 'logo.jpeg' or 'am.png' if available.
              // Let's stick safe with what was used in Splash or a generic Placeholder if unsure.
              // The user prompt said: "use icons or same text and in photo right side is logo so add im my screen also" for Splash.
              // For Login, they say "otp popup box photo will be shred in second box".
              // I'll place the illustration at the top.
              Center(
                child: Image.asset(
                  "assets/logo/am.png", // Using am.png (Logo/Illustration)
                  height: 365,
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 WELCOME TEXT
              RichText(
                text: const TextSpan(
                  text: "Welcome ",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "Shipper",
                      style: TextStyle(
                        color: AppColors.primary, // Orange accent
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "Please enter your sign in details.",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 PHONE INPUT FIELD
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),

                  // Prefix: Icon + +91
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone, color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "+91",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),

                  hintText: "Enter Phone Number",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),

                  // Borders
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 TERMS & BUTTON AT BOTTOM
              // Using a Spacer to push content down if screen is tall,
              // but SingleChildScrollView helps with keyboard.
              // Let's just use fixed spacing or Spacer if we want it pinned to bottom.
              // Design shows it relatively close to inputs.
              const Center(
                child: Text(
                  "By clicking Next, you agree with our",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Terms and Conditions",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    " and ",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),
              // Moved Checkbox logic mostly to just implicit "Clicking Next agrees".
              // The design snippet doesn't explicitly show a checkbox in the cropped view,
              // but previous code had it. The prompt says "same screen".
              // Design 1 "Welcome Shipper" shows "By clicking Next...".
              // It does NOT show a checkbox clearly in the text.
              // I will add a checkbox to be safe OR remove it if text says "By clicking Next".
              // The text says "By clicking Next, you agree...", which usually implies no checkbox needed.
              // But I will keep the boolean logic tied to a Checkbox if user wants explicit consent,
              // OR I will add a Checkbox row like before.
              // Let's add the checkbox back to be safe as per "Terms & Conditions" check.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: isAccepted,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      setState(() => isAccepted = v ?? false);
                    },
                  ),
                  const Text(
                    "I agree to the terms",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
