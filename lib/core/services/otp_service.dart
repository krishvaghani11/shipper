
import 'api_services.dart';

class OtpService {
  static Future<void> sendEmailOtp(String email) async {
    await ApiService.post(
      endpoint: "/send-otp",
      body: {
        "email": email,
      },
    );
  }
}

