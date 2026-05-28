import 'package:flutter/material.dart';

class QuizResultPage extends StatefulWidget {
  final Map result;
  final int score;

  const QuizResultPage({super.key, required this.result, required this.score});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _anim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.result['score_percent'] ?? 0).toDouble();
    final isPass = percent >= 50;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _anim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ICON RESULT
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(
                    isPass ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                    size: 90,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  isPass ? "Excellent!" : "Try Again!",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Your Result",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 30),

                // SCORE CARD
                Container(
                  width: 260,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${widget.score}",
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${percent.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: percent / 100,
                        backgroundColor: Colors.grey[200],
                        color: isPass ? Colors.green : Colors.red,
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // MESSAGE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    widget.result['message'] ?? "Keep practicing to improve!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (r) => r.isFirst);
                  },
                  child: const Text(
                    "Back Home",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
