import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl/core/constants/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Base URL của API, đảm bảo đã được cấu hình đúng
  // Thay thế bằng địa chỉ IP và cổng chính xác của máy chủ backend của bạn
  final String _authBaseUrl = 'http://192.168.10.155/api/v1/auth';

  // Phương thức đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': username,
          'password': password,
          'grant_type': 'password',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final accessToken = responseData['access_token'];

        // Lưu accessToken vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        return {'success': true, 'message': 'Đăng nhập thành công!'};
      } else {
        // Xử lý lỗi từ API
        String errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        try {
          final errorData = json.decode(response.body);
          if (errorData.containsKey('detail') &&
              errorData['detail'] is String) {
            errorMessage = errorData['detail'];
          }
        } catch (e) {
          print('Lỗi giải mã phản hồi khi đăng nhập (AuthService): $e');
          print(
            'Phản hồi thô khi đăng nhập lỗi (AuthService): ${response.body}',
          );
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Lỗi kết nối khi đăng nhập (AuthService): $e');
      return {
        'success': false,
        'message':
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng hoặc địa chỉ máy chủ.',
      };
    }
  }

  // Phương thức đăng ký
  Future<Map<String, dynamic>> register(
    String username,
    String password,
    String fullName,
  ) async {
    try {
      final url = Uri.parse('$_authBaseUrl/register');
      final Map<String, String> userData = {
        'username': username,
        'password': password,
        'full_name': fullName,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Đăng ký thành công! Vui lòng đăng nhập.',
        };
      } else {
        // Xử lý lỗi từ API
        String errorMessage = 'Đăng ký thất bại. Vui lòng thử lại.';
        try {
          final errorData = json.decode(response.body);
          if (errorData.containsKey('detail') &&
              errorData['detail'] is String) {
            errorMessage = errorData['detail'];
          } else if (errorData.containsKey('detail') &&
              errorData['detail'] is List) {
            if (errorData['detail'].isNotEmpty &&
                errorData['detail'][0].containsKey('msg')) {
              errorMessage = errorData['detail'][0]['msg'];
            }
          }
        } catch (e) {
          print('Lỗi giải mã phản hồi khi đăng ký (AuthService): $e');
          print('Phản hồi thô khi đăng ký lỗi (AuthService): ${response.body}');
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Lỗi kết nối khi đăng ký (AuthService): $e');
      return {
        'success': false,
        'message':
            'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng hoặc địa chỉ máy chủ.',
      };
    }
  }

  // Phương thức kiểm tra trạng thái đăng nhập (có thể dùng trong main.dart)
  static Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null && accessToken.isNotEmpty;
  }

  // Phương thức logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // Xóa access token
    // Nếu bạn có refresh token hoặc các thông tin đăng nhập khác, hãy xóa chúng ở đây.

    // (Tùy chọn) Gọi API logout backend nếu server của bạn cần invalidate token
    // Tuy nhiên, với JWT, việc xóa token client-side thường là đủ để người dùng không còn được xác thực.
    // try {
    //   final String _authBaseUrl = 'http://10.241.181.118:8000/api/v1/auth';
    //   final response = await http.post(Uri.parse('$_authBaseUrl/logout'), headers: {
    //     'Authorization': 'Bearer YOUR_SAVED_ACCESS_TOKEN', // Cần lấy token đã lưu để gửi
    //   });
    //   if (response.statusCode == 200) {
    //     print("Logged out from backend successfully.");
    //   } else {
    //     print("Failed to logout from backend: ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Error calling backend logout: $e");
    // }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    print("TOKEN = $token");

    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$_authBaseUrl/me"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("STATUS = ${response.statusCode}");
    print("BODY = ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}
