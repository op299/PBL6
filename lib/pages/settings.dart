import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        child: Stack(
          children: [
            // Header with back button
            Positioned(
              top: 50 * scale,
              left: 30 * scale,
              right: 30 * scale,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 40 * scale,
                      color: const Color(0xFF1C1C1C),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontSize: 50 * scale,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1C1C1C),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Settings content
            Positioned(
              top: 200 * scale,
              left: 50 * scale,
              right: 50 * scale,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'Change app language',
                    scale: scale,
                  ),
                  SizedBox(height: 30 * scale),
                  _buildSettingItem(
                    icon: Icons.brightness_6_rounded,
                    title: 'Dark Mode',
                    subtitle: 'Toggle dark mode',
                    scale: scale,
                  ),
                  SizedBox(height: 30 * scale),
                  _buildSettingItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    scale: scale,
                  ),
                  SizedBox(height: 30 * scale),
                  _buildSettingItem(
                    icon: Icons.info_rounded,
                    title: 'About',
                    subtitle: 'App version and info',
                    scale: scale,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double scale,
  }) {
    return Container(
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20 * scale),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFEBF4EE)],
        ),
        border: Border.all(color: const Color(0xFFE6ECE5), width: 2 * scale),
      ),
      child: Row(
        children: [
          Icon(icon, size: 50 * scale, color: const Color(0xFF1C1C1C)),
          SizedBox(width: 20 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24 * scale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1C1C1C),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14 * scale,
                  color: const Color(0xFF778574),
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 24 * scale,
            color: const Color(0xFF89E287),
          ),
        ],
      ),
    );
  }
}
