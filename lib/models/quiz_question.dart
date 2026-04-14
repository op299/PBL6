class QuizQuestion {
  final String id;
  final String imageUrl; // URL ảnh vật thể (từ ESP32 chụp)
  final String classNameEn; // Tên tiếng Anh (Đáp án đúng)
  final String classNameVn; // Tên tiếng Việt (Dùng để hỏi)
  List<String> options; // Danh sách 4 đáp án
  final String correctAnswer; // Đáp án đúng

  QuizQuestion({
    required this.id,
    required this.imageUrl,
    required this.classNameEn,
    required this.classNameVn,
    required this.options,
    required this.correctAnswer,
  });
  void shuffleOptions() {
    options.shuffle();
  }
}
