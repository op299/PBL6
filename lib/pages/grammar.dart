import 'package:flutter/material.dart';
import 'package:pbl/widgets/vocabulary_card.dart';
import 'package:pbl/widgets/bottom_navigation.dart';
import 'package:pbl/routes.dart';
import 'package:pbl/models/vocabulary_category.dart';

class GrammarPage extends StatelessWidget {
  const GrammarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    final List<VocabularyCategory> categories = [
      VocabularyCategory(icon: Icons.wc_rounded, label: 'Masculine\nFeminine'),
      VocabularyCategory(icon: Icons.group_rounded, label: 'Singular\nPlural'),
      VocabularyCategory(icon: Icons.label_rounded, label: 'Adjective'),
      VocabularyCategory(
        icon: Icons.trending_flat_rounded,
        label: 'Prepositions',
      ),
      VocabularyCategory(
        icon: Icons.help_outline_rounded,
        label: 'Interrogative\nArticles',
      ),
      VocabularyCategory(
        icon: Icons.person_rounded,
        label: 'Personal\nPronouns',
      ),
      VocabularyCategory(icon: Icons.notes_rounded, label: 'Sentences'),
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
                'Arabic Grammar',
                style: TextStyle(
                  fontSize: 50 * scale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF66C457),
                ),
              ),
            ),
            // Grid of grammar cards with scroll
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
