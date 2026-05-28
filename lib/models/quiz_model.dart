class QuizQuestion {
  final int questionIndex;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String objectNameEn;
  final String objectNameVn;

  QuizQuestion({
    required this.questionIndex,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.objectNameEn,
    required this.objectNameVn,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionIndex: json['question_index'] ?? 0,
      questionText: json['question_text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      objectNameEn: json['object_name_en'] ?? '',
      objectNameVn: json['object_name_vn'] ?? '',
    );
  }
}

class QuizSession {
  final String sessionId;
  final String quizType;
  final List<QuizQuestion> questions;

  QuizSession({
    required this.sessionId,
    required this.quizType,
    required this.questions,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      sessionId: json['session_id'] ?? '',
      quizType: json['quiz_type'] ?? '',
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => QuizQuestion.fromJson(e))
          .toList(),
    );
  }
}
