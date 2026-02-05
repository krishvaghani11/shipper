import 'token_service.dart';
import 'api_services.dart';

class OtpService {
  static String? userEmail;
  static String? userMobile; // ✅ Store Mobile

  static Future<void> initLogin(String mobile, String email) async {
    userEmail = email;
    userMobile = mobile;
    await ApiService.post(
      endpoint: "/init-login",
      body: {"mobileNumber": mobile, "email": email},
    );
  }

  static Future<void> sendEmailOtp(String email) async {
    await ApiService.post(
      endpoint: "/send-email-otp", // Removed redundant /auth
      body: {"email": email},
    );
  }

  static Future<dynamic> verifyOtp(String otp) async {
    final body = {
      "otp": otp,
      if (userEmail != null && userEmail!.isNotEmpty) "email": userEmail,
      if (userMobile != null && userMobile!.isNotEmpty)
        "mobileNumber": userMobile,
    };

    final response = await ApiService.post(endpoint: "/verify-otp", body: body);

    if (response["success"] == true && response["token"] != null) {
      await TokenService.saveToken(response["token"]);
    }

    return response;
  }
}
