import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'jwt_token';

  /// Save token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Delete token (Logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }
}
