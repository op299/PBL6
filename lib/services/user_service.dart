import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _baseUrl = "http://10.67.143.118:8000/api/v1/auth";

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken");

      if (token == null || token.isEmpty) {
        return {"success": false, "message": "Chưa đăng nhập"};
      }

      final response = await http.get(
        Uri.parse("$_baseUrl/me"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": "Không lấy được thông tin"};
      }
    } catch (e) {
      return {"success": false, "message": "Lỗi kết nối server"};
    }
  }
}
