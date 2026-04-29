import 'package:flutter/material.dart';
import 'package:pbl/routes.dart';
import 'package:pbl/services/auth_service.dart'; // Import AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : const Color(0xFF66C457),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (result['success']) {
      _showSnackBar(result['message'], isError: false);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.dashboard, (route) => false);
    } else {
      _showSnackBar(result['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFEAF0EA)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 80 * scale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đăng Nhập',
                  style: TextStyle(
                    fontSize: 80 * scale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF66C457),
                  ),
                ),
                SizedBox(height: 50 * scale),
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Tên đăng nhập',
                  icon: Icons.person,
                  scale: scale,
                ),
                SizedBox(height: 30 * scale),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Mật khẩu',
                  icon: Icons.lock,
                  isPassword: true,
                  scale: scale,
                ),
                SizedBox(height: 60 * scale),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF66C457))
                    : SizedBox(
                        width: double.infinity,
                        height: 120 * scale,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66C457),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30 * scale),
                            ),
                            textStyle: TextStyle(
                              fontSize: 40 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Đăng Nhập'),
                        ),
                      ),
                SizedBox(height: 40 * scale),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.register);
                  },
                  child: Text(
                    'Chưa có tài khoản? Đăng ký ngay',
                    style: TextStyle(
                      fontSize: 30 * scale,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    required double scale,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(fontSize: 35 * scale, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 35 * scale, color: Colors.grey[400]),
        prefixIcon: Icon(
          icon,
          size: 45 * scale,
          color: const Color(0xFF66C457),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30 * scale),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 25 * scale,
          horizontal: 30 * scale,
        ),
      ),
    );
  }
}
