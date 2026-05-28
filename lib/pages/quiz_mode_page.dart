import 'package:flutter/material.dart';
import 'package:pbl/models/quiz_model.dart';
import 'package:pbl/pages/quiz_play_page.dart';
import 'package:pbl/services/quiz_service.dart';

class QuizModePage extends StatelessWidget {
  const QuizModePage({super.key});

  Future<void> startQuiz(BuildContext context, String type) async {
    final service = QuizService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final session = await service.generateQuiz(userId: 1, type: type, limit: 5);

    if (!context.mounted) return;
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QuizPlayPage(session: session)),
    );
  }

  // 🔥 HISTORY BOTTOM SHEET
  void showHistory(BuildContext context) async {
    final service = QuizService();
    final res = await service.getHistory(userId: 1);

    if (res == null) return;

    final List history = res["results"] ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 500,
          child: Column(
            children: [
              const Text(
                "Quiz History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (_, i) {
                    final item = history[i];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["quiz_type"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Score: ${item["score_percent"]}%"),
                            ],
                          ),
                          Text(
                            "${item["score"]}/${item["total_questions"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
    String type,
  ) {
    return GestureDetector(
      onTap: () => startQuiz(context, type),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(desc, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Mode"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => showHistory(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard(
              context,
              "English → Vietnamese",
              "Chọn nghĩa tiếng Việt",
              Icons.translate,
              Colors.blue,
              "en_to_vn",
            ),
            buildCard(
              context,
              "Vietnamese → English",
              "Chọn nghĩa tiếng Anh",
              Icons.language,
              Colors.green,
              "vn_to_en",
            ),
            buildCard(
              context,
              "Pronunciation",
              "Chọn phát âm đúng",
              Icons.volume_up,
              Colors.orange,
              "pronunciation",
            ),
          ],
        ),
      ),
    );
  }
}
