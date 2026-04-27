import 'package:flutter/material.dart';
import 'package:pbl/routes.dart';
import 'package:pbl/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  bool _isLoading = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF66C457),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final fullName = _fullNameController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        fullName.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Mật khẩu phải từ 6 ký tự trở lên.");
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Mật khẩu nhập lại không khớp.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.register(username, password, fullName);

    setState(() {
      _isLoading = false;
    });

    if (result["success"]) {
      _showSnackBar(result["message"], isError: false);

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      _showSnackBar(result["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).size.width / 1080;

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
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: 120 * scale,
                  color: const Color(0xFF66C457),
                ),

                SizedBox(height: 20 * scale),

                Text(
                  "Đăng Ký",
                  style: TextStyle(
                    fontSize: 80 * scale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF66C457),
                  ),
                ),

                SizedBox(height: 60 * scale),

                _buildTextField(
                  controller: _fullNameController,
                  hintText: "Tên đầy đủ",
                  icon: Icons.badge,
                  scale: scale,
                ),

                SizedBox(height: 30 * scale),

                _buildTextField(
                  controller: _usernameController,
                  hintText: "Tên đăng nhập",
                  icon: Icons.person,
                  scale: scale,
                ),

                SizedBox(height: 30 * scale),

                _buildTextField(
                  controller: _passwordController,
                  hintText: "Mật khẩu",
                  icon: Icons.lock,
                  isPassword: true,
                  hideText: _hidePassword,
                  onToggle: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  scale: scale,
                ),

                SizedBox(height: 30 * scale),

                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: "Nhập lại mật khẩu",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  hideText: _hideConfirmPassword,
                  onToggle: () {
                    setState(() {
                      _hideConfirmPassword = !_hideConfirmPassword;
                    });
                  },
                  scale: scale,
                ),

                SizedBox(height: 60 * scale),

                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF66C457))
                    : SizedBox(
                        width: double.infinity,
                        height: 120 * scale,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66C457),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30 * scale),
                            ),
                          ),
                          child: Text(
                            "Đăng Ký",
                            style: TextStyle(
                              fontSize: 40 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                SizedBox(height: 35 * scale),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: Text(
                    "Đã có tài khoản? Đăng nhập",
                    style: TextStyle(
                      fontSize: 30 * scale,
                      color: Colors.grey[700],
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
    required double scale,
    bool isPassword = false,
    bool hideText = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? hideText : false,
      style: TextStyle(fontSize: 35 * scale, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 32 * scale, color: Colors.grey[500]),
        prefixIcon: Icon(
          icon,
          size: 45 * scale,
          color: const Color(0xFF66C457),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onToggle,
                icon: Icon(hideText ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 25 * scale,
          horizontal: 30 * scale,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30 * scale),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
