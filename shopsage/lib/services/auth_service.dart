import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/auth_result.dart';

class AuthService {
  Future<AuthResult> login({required String email, required String password}) {
    return _post('/login', {'email': email.trim(), 'password': password});
  }

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _post('/register', {
  'name': name.trim(),
  'email': email.trim().toLowerCase(),
  'password': password,
});
  }

  Future<AuthResult> forgotPassword({required String email}) {
    return _post('/forgot-password', {'email': email.trim()});
  }

  Future<AuthResult> _post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final decoded = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(decoded['message']?.toString() ?? 'Request failed');
      }

      final result = AuthResult.fromJson(decoded);
      if (result.accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', result.accessToken!);
        if (result.refreshToken != null) {
          await prefs.setString('refreshToken', result.refreshToken!);
        }
      }
      return result;
    } on FormatException {
      throw Exception('Server returned invalid data');
    } catch (error) {
      final text = error.toString().replaceFirst('Exception: ', '');
      throw Exception(text);
    }
  }
}
