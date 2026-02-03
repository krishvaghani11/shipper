import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.29.187:5000/api/auth";

  static Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }

  // ✅ ADDED GET METHOD
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.body}");
    }
  }
}
