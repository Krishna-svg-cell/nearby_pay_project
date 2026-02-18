import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  // Uses the base URL from your main ApiService
  final String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> login(String phone, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "phone": phone,
          "pin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  Future<Map<String, dynamic>> register(String name, String phone, String pin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "pin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['detail'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }
}