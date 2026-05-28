import 'package:flutter/material.dart';
import 'package:pbl/models/quiz_model.dart';
import 'package:pbl/pages/result_page.dart';
import 'package:pbl/services/quiz_service.dart';

class QuizPlayPage extends StatefulWidget {
  final QuizSession session;

  const QuizPlayPage({super.key, required this.session});

  @override
  State<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends State<QuizPlayPage>
    with SingleTickerProviderStateMixin {
  int index = 0;
  int score = 0;
  String? selected;

  List<Map> answers = [];

  void choose(String answer) {
    final q = widget.session.questions[index];

    setState(() => selected = answer);

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      answers.add({
        "question_index": q.questionIndex,
        "user_answer": answer,
        "time_taken_seconds": 2,
      });

      if (answer == q.correctAnswer) {
        score++;
      }

      if (index < widget.session.questions.length - 1) {
        setState(() {
          index++;
          selected = null;
        });
      } else {
        finish();
      }
    });
  }

  void finish() async {
    final res = await QuizService().submitQuiz({
      "user_id": 1,
      "session_id": widget.session.sessionId,
      "quiz_type": widget.session.quizType,
      "answers": answers,
      "total_time_seconds": 20,
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultPage(result: res ?? {}, score: score),
      ),
    );
  }

  Color optionColor(String option, String correct) {
    if (selected == null) return Colors.white;

    if (option != selected) return Colors.white;

    return option == correct ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.session.questions[index];
    final progress = (index + 1) / widget.session.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xffeef2f7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          "Question ${index + 1}/${widget.session.questions.length}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 25),

            // QUESTION CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                q.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // OPTIONS
            ...q.options.map((e) {
              final isSelected = selected == e;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () => choose(e),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: optionColor(e, q.correctAnswer),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
