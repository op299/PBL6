import 'package:flutter/material.dart';
import 'package:pbl/routes.dart';
import 'package:pbl/services/auth_service.dart';
import 'package:pbl/widgets/bottom_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();

  String username = "Đang tải...";
  String fullName = "Đang tải...";
  String role = "Đang tải...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await authService.getProfile();

    if (data != null) {
      setState(() {
        username = data["username"] ?? "";
        fullName = data["full_name"] ?? "";
        role = data["role"] ?? "";
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void logout() async {
    await AuthService.logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Widget infoCard({
    required IconData icon,
    required String title,
    required String value,
    required double scale,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 25 * scale),
      padding: EdgeInsets.all(25 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(18 * scale),
            decoration: BoxDecoration(
              color: const Color(0xFF66C457).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF66C457), size: 38 * scale),
          ),
          SizedBox(width: 25 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24 * scale, color: Colors.grey),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32 * scale,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1C1C1C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double scale = MediaQuery.of(context).size.width / 1080;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "PROFILE",
          style: TextStyle(
            fontSize: 42 * scale,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 2,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF66C457)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(35 * scale),
                child: Column(
                  children: [
                    SizedBox(height: 20 * scale),

                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 90 * scale,
                        backgroundColor: const Color(0xFF66C457),
                        child: Icon(
                          Icons.person,
                          size: 110 * scale,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 30 * scale),

                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 45 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10 * scale),

                    Text(
                      "@$username",
                      style: TextStyle(
                        fontSize: 28 * scale,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 50 * scale),

                    infoCard(
                      icon: Icons.person_outline,
                      title: "Username",
                      value: username,
                      scale: scale,
                    ),

                    infoCard(
                      icon: Icons.badge_outlined,
                      title: "Full Name",
                      value: fullName,
                      scale: scale,
                    ),

                    infoCard(
                      icon: Icons.workspace_premium_outlined,
                      title: "Role",
                      value: role,
                      scale: scale,
                    ),

                    SizedBox(height: 40 * scale),

                    SizedBox(
                      width: double.infinity,
                      height: 115 * scale,
                      child: ElevatedButton.icon(
                        onPressed: logout,
                        icon: Icon(Icons.logout, size: 38 * scale),
                        label: Text(
                          "Đăng Xuất",
                          style: TextStyle(
                            fontSize: 34 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25 * scale),
                          ),
                          elevation: 6,
                        ),
                      ),
                    ),

                    SizedBox(height: 180 * scale),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: BottomNavigation(
        scale: scale,
        onHomeTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        },
      ),
    );
  }
}
