import 'package:flutter/material.dart';
import 'package:pbl/widgets/vocabulary_card.dart';
import 'package:pbl/widgets/bottom_navigation.dart';
import 'package:pbl/routes.dart';


class VocabularyPage1 extends StatelessWidget {
  const VocabularyPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    final List<VocabularyCategory> categories = [
      VocabularyCategory(icon: Icons.text_fields_rounded, label: 'Alphabet'),
      VocabularyCategory(icon: Icons.looks_3_rounded, label: 'Numbers'),
      VocabularyCategory(icon: Icons.calendar_today_rounded, label: 'Days'),
      VocabularyCategory(icon: Icons.schedule_rounded, label: 'Time'),
      VocabularyCategory(icon: Icons.restaurant_rounded, label: 'Food'),
      VocabularyCategory(icon: Icons.palette_rounded, label: 'Colors'),
      VocabularyCategory(icon: Icons.public_rounded, label: 'Countries'),
      VocabularyCategory(icon: Icons.pets_rounded, label: 'Animals'),
      VocabularyCategory(icon: Icons.language_rounded, label: 'Language'),
      VocabularyCategory(
        icon: Icons.accessibility_rounded,
        label: 'Body Parts',
      ),
      VocabularyCategory(icon: Icons.wb_sunny_rounded, label: 'Solar Months'),
      VocabularyCategory(
        icon: Icons.nights_stay_rounded,
        label: 'Islamic Months',
      ),
      VocabularyCategory(icon: Icons.place, label: 'Place'),
    ];

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
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(top: 50 * scale, bottom: 30 * scale),
              child: Text(
                'Vocabulary',
                style: TextStyle(
                  fontSize: 50 * scale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF66C457),
                ),
              ),
            ),
            // Grid of vocabulary cards with scroll
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40 * scale,
                    vertical: 20 * scale,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25 * scale,
                      crossAxisSpacing: 25 * scale,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return VocabularyCard(
                        icon: categories[index].icon,
                        label: categories[index].label,
                        scale: scale,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Bottom Navigation
            BottomNavigation(
              scale: scale,
              onHomeTap: () {
                Navigator.pushNamed(context, AppRoutes.dashboard);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VocabularyCategory {
  final IconData icon;
  final String label;

  VocabularyCategory({required this.icon, required this.label});
}
