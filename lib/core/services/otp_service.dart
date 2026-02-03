import 'api_services.dart';

class OtpService {
  static String? userEmail;

  static Future<void> initLogin(String mobile, String email) async {
    userEmail = email; // ✅ STORE EMAIL
    await ApiService.post(
      endpoint: "/init-login", // Removed redundant /auth
      body: {"mobileNumber" : mobile, "email": email},
    );
  }

  static Future<void> sendEmailOtp(String email) async {
    await ApiService.post(
      endpoint: "/send-email-otp", // Removed redundant /auth
      body: {"email": email},
    );
  }

  static Future<void> verifyOtp(String email, String otp) async {
    await ApiService.post(
      endpoint: "/verify-otp", // Removed redundant /auth
      body: {"email": email, "otp": otp},
    );
  }
}
