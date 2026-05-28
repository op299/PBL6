import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_model.dart';

class QuizService {
  final String baseUrl = 'http://172.31.99.31:8000/api/v1/quiz';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // ================= GENERATE QUIZ =================
  Future<QuizSession> generateQuiz({
    required int userId,
    required String type,
    required int limit,
  }) async {
    try {
      final token = await _getToken();

      final res = await http.post(
        Uri.parse("$baseUrl/generate"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "user_id": userId,
          "quiz_type": type,
          "limit": limit,
          "objects": null,
          "from_history": true,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        print("QUIZ RESPONSE: $data");

        return QuizSession.fromJson(data);
      }
    } catch (e) {
      print("BE OFF → MOCK: $e");
    }

    // MOCK fallback
    return QuizSession(
      sessionId: "mock",
      quizType: type,
      questions: [
        QuizQuestion(
          questionIndex: 0,
          questionText: "Cat nghĩa là gì?",
          options: ["chó", "mèo", "cá", "bò"],
          correctAnswer: "mèo",
          objectNameEn: "cat",
          objectNameVn: "mèo",
        ),
      ],
    );
  }

  Future<Map<String, dynamic>?> getHistory({required int userId}) async {
    try {
      final token = await _getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/history?user_id=$userId&limit=20"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print("HISTORY ERROR: $e");
    }

    return null;
  }

  // ================= SUBMIT =================
  Future<Map<String, dynamic>> submitQuiz(Map body) async {
    try {
      final token = await _getToken();

      final res = await http.post(
        Uri.parse("$baseUrl/submit"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (e) {
      print("SUBMIT ERROR: $e");
    }

    return {
      "success": true,
      "score": 1,
      "score_percent": 100,
      "message": "Mock result",
    };
  }
}
