import 'dart:convert';
import 'package:http/http.dart' as http;
import 'encryption_service.dart';

class ApiService {
  // TODO: CHANGE THIS TO YOUR COMPUTER'S LOCAL IP
  static const baseUrl = "http://10.202.243.190:8000";

  Future<Map<String, dynamic>> login(String phone, String pin) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone, "pin": pin}),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Login Failed");
    
  }

  Future<Map<String, dynamic>> register(
      String name, String phone, String pin) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "phone": phone, "pin": pin}),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Registration Failed");
  }

  Future<List<dynamic>> getNearbyUsers(String myPhone) async {
    final res = await http
        .get(Uri.parse('$baseUrl/user/nearby?exclude_phone=$myPhone'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    return [];
  }

  Future<bool> sendMoney(String sender, String receiver, double amount) async {
    // SECURITY: Encrypt the amount before it leaves the device
    final encryptedAmount = EncryptionService.encryptData(amount.toString());

    final res = await http.post(
      Uri.parse('$baseUrl/wallet/transact'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "sender_phone": sender,
        "receiver_phone": receiver,
        "encrypted_amount": encryptedAmount,
      }),
    );
    return res.statusCode == 200;
  }

  Future<List<dynamic>> getHistory(String phone) async {
    final res = await http.get(Uri.parse('$baseUrl/wallet/history/$phone'));
    return jsonDecode(res.body);
  }
}
