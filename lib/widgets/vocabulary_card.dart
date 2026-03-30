import 'package:flutter/material.dart';

class VocabularyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double scale;
  final VoidCallback? onTap;

  const VocabularyCard({
    super.key,
    required this.icon,
    required this.label,
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30 * scale),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFEBF4EE)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0C130A).withOpacity(0.15),
              offset: Offset(0, 5 * scale),
              blurRadius: 8 * scale,
            ),
          ],
          border: Border.all(
            color: const Color(0xFFE6ECE5),
            width: 1.5 * scale,
          ),
        ),
        child: Stack(
          children: [
            // Decorative Circle 1
            Positioned(
              top: 10 * scale,
              right: 10 * scale,
              child: CircleAvatar(
                radius: 15 * scale,
                backgroundColor: const Color(0xFF89E287),
              ),
            ),
            // Decorative Circle 2
            Positioned(
              bottom: 15 * scale,
              left: 10 * scale,
              child: CircleAvatar(
                radius: 10 * scale,
                backgroundColor: const Color(0xFF89E287).withOpacity(0.6),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 50 * scale, color: const Color(0xFF1C1C1C)),
                  SizedBox(height: 12 * scale),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8 * scale),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30 * scale,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1C1C1C),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
