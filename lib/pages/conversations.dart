import 'package:flutter/material.dart';
import 'package:pbl/widgets/vocabulary_card.dart';
import 'package:pbl/widgets/bottom_navigation.dart';
import 'package:pbl/routes.dart';
import 'package:pbl/models/vocabulary_category.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    final List<VocabularyCategory> categories = [
      VocabularyCategory(icon: Icons.handshake_rounded, label: 'Greetings'),
      VocabularyCategory(icon: Icons.people_rounded, label: 'Introduction'),
      VocabularyCategory(icon: Icons.school_rounded, label: 'Students Talk'),
      VocabularyCategory(icon: Icons.location_on_rounded, label: 'Directions'),
      VocabularyCategory(icon: Icons.flight_rounded, label: 'Flight'),
      VocabularyCategory(icon: Icons.music_note_rounded, label: 'Hobbies'),
      VocabularyCategory(icon: Icons.cloud_rounded, label: 'Weather'),
      VocabularyCategory(
        icon: Icons.breakfast_dining_rounded,
        label: 'Breakfast',
      ),
      VocabularyCategory(icon: Icons.local_cafe_rounded, label: 'Coffee Shop'),
      VocabularyCategory(icon: Icons.restaurant_rounded, label: 'At Lunch'),
      VocabularyCategory(icon: Icons.dinner_dining_rounded, label: 'At Dinner'),
      VocabularyCategory(
        icon: Icons.schedule_rounded,
        label: 'Talk about Time',
      ),
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
                'Arabic Conversations',
                style: TextStyle(
                  fontSize: 50 * scale,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF66C457),
                ),
              ),
            ),

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
