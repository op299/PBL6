import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final double scale;
  final VoidCallback? onHomeTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onSettingTap;

  const BottomNavigation({
    super.key,
    required this.scale,
    this.onHomeTap,
    this.onFavoriteTap,
    this.onSettingTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250 * scale,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background shape
          Container(
            height: 200 * scale,
            decoration: const BoxDecoration(
              color: Color(0xFFBBC0BB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          ),
          // Icons
          Padding(
            padding: EdgeInsets.only(
              bottom: 40 * scale,
              left: 60 * scale,
              right: 60 * scale,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onFavoriteTap,
                  child: _NavIcon(
                    icon: Icons.favorite_rounded,
                    label: 'FAVORITE',
                    scale: scale,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onSettingTap,
                  child: _NavIcon(
                    icon: Icons.camera_rear_outlined,
                    label: 'WebSocket',
                    scale: scale,
                  ),
                ),
              ],
            ),
          ),
          // Center Home Button
          Positioned(
            bottom: 60 * scale,
            child: GestureDetector(
              onTap: onHomeTap,
              child: Container(
                width: 180 * scale,
                height: 180 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66C457), Color(0xFF154D0C)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15 * scale,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.home_rounded,
                  size: 100 * scale,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final double scale;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 60 * scale, color: const Color(0xFF778574)),
        Text(
          label,
          style: TextStyle(
            fontSize: 20 * scale,
            color: const Color(0xFF778574),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
