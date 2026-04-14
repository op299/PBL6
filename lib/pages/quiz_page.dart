import 'package:flutter/material.dart';
import 'package:pbl/models/quiz_question.dart';
import 'package:pbl/data/mock_quiz_data.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<QuizQuestion> _quizQuestions;
  int _currentIndex = 0;
  int _score = 0;
  String _selectedAnswer = "";
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu và xáo trộn danh sách câu hỏi
    _quizQuestions = List.from(MockData.questions)..shuffle();
    // Trộn đáp án của câu hỏi đầu tiên
    _quizQuestions[_currentIndex].shuffleOptions();
  }

  void _handleAnswer(String selectedOption) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = selectedOption;
      _isAnswered = true;
      if (selectedOption == _quizQuestions[_currentIndex].correctAnswer) {
        _score++;
      }
    });

    // Chờ 1.2 giây rồi qua câu tiếp theo
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (_currentIndex < _quizQuestions.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _selectedAnswer = "";
          _quizQuestions[_currentIndex]
              .shuffleOptions(); // Trộn đáp án câu tiếp theo
        });
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hoàn thành bài học!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Color(0xFF66C457), size: 80),
            const SizedBox(height: 20),
            Text("Bạn đã đạt được:", style: const TextStyle(fontSize: 18)),
            Text(
              "${_score}/${_quizQuestions.length}",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66C457),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                Navigator.pop(context); // Quay lại Dashboard
              },
              child: const Text(
                "Về trang chủ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;
    final currentQuestion = _quizQuestions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text("Object Quiz"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _quizQuestions.length,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF66C457),
            minHeight: 10 * scale,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40 * scale),
                  // Hiển thị số câu hiện tại
                  Text(
                    "Câu ${_currentIndex + 1}/${_quizQuestions.length}",
                    style: TextStyle(
                      fontSize: 35 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),

                  SizedBox(height: 30 * scale),

                  // Khung ảnh
                  Container(
                    width: 950 * scale,
                    height: 650 * scale,
                    margin: EdgeInsets.symmetric(horizontal: 40 * scale),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50 * scale),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 15),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(currentQuestion.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 50 * scale),

                  Text(
                    "Đây là đồ vật gì?",
                    style: TextStyle(
                      fontSize: 45 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "(${currentQuestion.classNameVn})",
                    style: TextStyle(fontSize: 35 * scale, color: Colors.grey),
                  ),

                  SizedBox(height: 50 * scale),

                  // Danh sách nút đáp án
                  ...currentQuestion.options.map((option) {
                    Color btnColor = Colors.white;
                    if (_isAnswered) {
                      if (option == currentQuestion.correctAnswer) {
                        btnColor = const Color(0xFFC8E6C9); // Xanh khi đúng
                      } else if (option == _selectedAnswer) {
                        btnColor = const Color(0xFFFFCDD2); // Đỏ khi chọn sai
                      }
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 80 * scale,
                        vertical: 15 * scale,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 140 * scale,
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30 * scale),
                              side: BorderSide(
                                color:
                                    _isAnswered &&
                                        option == currentQuestion.correctAnswer
                                    ? const Color(0xFF66C457)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 40 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 50 * scale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
