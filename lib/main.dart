import 'package:flutter/material.dart';
import 'package:pbl/routes.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm để kiểm tra token

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter binding đã khởi tạo
//   _checkLoginStatus().then((isLoggedIn) {
//     runApp(MyApp(isLoggedIn: isLoggedIn));
//   });
// }

// Future<bool> _checkLoginStatus() async {
//   final prefs = await SharedPreferences.getInstance();
//   final accessToken = prefs.getString('accessToken');
//   return accessToken != null && accessToken.isNotEmpty;
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn; // Thêm biến này
//   const MyApp({super.key, required this.isLoggedIn}); // Cập nhật constructor

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PBL Arabic App', // Nhắc nhở: Có thể đổi thành "PBL English App"
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF66C457)),
//         useMaterial3: true,
//       ),
//       // Quyết định initialRoute dựa trên trạng thái đăng nhập
//       initialRoute: isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,
//       routes: AppRoutes.getRoutes(),
//     );
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PBL Arabic App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF66C457)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.dashboard,
      routes: AppRoutes.getRoutes(),
    );
  }
}