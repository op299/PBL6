import 'package:flutter/material.dart';
import 'package:pbl/routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LEARNING',
          style: TextStyle(
            fontSize: 50 * scale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1C1C1C),
            letterSpacing: 2 * scale,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),

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

        child: SingleChildScrollView(
          child: SizedBox(
            height: 2000 * scale,
            child: Stack(
              children: [
                _buildFeatureCard(
                  top: 150 * scale,
                  left: 50 * scale,
                  width: 475 * scale,
                  height: 450 * scale,
                  title: 'VOCABULARY',
                  icon: Icons.menu_book_rounded,
                  scale: scale,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.vocabulary);
                  },
                ),

                _buildFeatureCard(
                  top: 150 * scale,
                  left: 555 * scale,
                  width: 475 * scale,
                  height: 450 * scale,
                  title: 'GRAMMAR',
                  icon: Icons.spellcheck_rounded,
                  scale: scale,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.grammar);
                  },
                ),

                _buildFeatureCard(
                  top: 750 * scale,
                  left: 50 * scale,
                  width: 475 * scale,
                  height: 450 * scale,
                  title: 'CONVERSATIONS',
                  icon: Icons.people_alt_rounded,
                  scale: scale,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.conversations);
                  },
                ),

                _buildFeatureCard(
                  top: 750 * scale,
                  left: 555 * scale,
                  width: 475 * scale,
                  height: 450 * scale,
                  title: 'QUIZ',
                  icon: Icons.extension_rounded,
                  scale: scale,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.quiz);
                  },
                ),

                _buildLargeCard(
                  top: 1400 * scale,
                  left: 50 * scale,
                  width: 980 * scale,
                  height: 320 * scale,
                  title: 'SAVED FILE',
                  icon: Icons.download_done_rounded,
                  scale: scale,
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomNav(scale, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= FEATURE CARD =================
  Widget _buildFeatureCard({
    required double top,
    required double left,
    required double width,
    required double height,
    required String title,
    required IconData icon,
    required double scale,
    VoidCallback? onTap,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40 * scale),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFEBF4EE)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0C130A).withOpacity(0.25),
                offset: Offset(0, 8 * scale),
                blurRadius: 10 * scale,
              ),
            ],
            border: Border.all(
              color: const Color(0xFFE6ECE5),
              width: 2 * scale,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40 * scale,
                right: 40 * scale,
                child: CircleAvatar(
                  radius: 25 * scale,
                  backgroundColor: const Color(0xFF89E287),
                ),
              ),

              Positioned(
                bottom: 60 * scale,
                left: 40 * scale,
                child: CircleAvatar(
                  radius: 15 * scale,
                  backgroundColor: const Color(0xFF89E287),
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 80 * scale,
                      color: const Color(0xFF1C1C1C),
                    ),

                    SizedBox(height: 20 * scale),

                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 28 * scale,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: const Color(0xFF1C1C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LARGE CARD =================
  Widget _buildLargeCard({
    required double top,
    required double left,
    required double width,
    required double height,
    required String title,
    required IconData icon,
    required double scale,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 40 * scale),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40 * scale),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFEBF4EE)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0C130A).withOpacity(0.25),
              offset: Offset(0, 8 * scale),
              blurRadius: 10 * scale,
            ),
          ],
          border: Border.all(color: const Color(0xFFE6ECE5), width: 2 * scale),
        ),
        child: Row(
          children: [
            Icon(icon, size: 100 * scale, color: const Color(0xFF1C1C1C)),

            SizedBox(width: 40 * scale),

            Text(
              title,
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C1C1C),
              ),
            ),

            const Spacer(),

            const ColorFiltered(
              colorFilter: ColorFilter.mode(Color(0xFF89E287), BlendMode.srcIn),
              child: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav(double scale, BuildContext context) {
    return SizedBox(
      height: 250 * scale,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
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

          Padding(
            padding: EdgeInsets.only(
              bottom: 40 * scale,
              left: 60 * scale,
              right: 60 * scale,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavIcon(Icons.favorite_rounded, 'FAVORITE', scale),

                const Spacer(),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                  child: _buildNavIcon(Icons.person_rounded, 'PROFILE', scale),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 60 * scale,
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
        ],
      ),
    );
  }

  // ================= NAV ICON =================
  Widget _buildNavIcon(IconData icon, String label, double scale) {
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
