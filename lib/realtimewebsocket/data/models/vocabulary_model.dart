class VocabularyData {
  final String wordEn;
  final String wordVn;
  final String exampleEn;
  final String audioUrl;

  VocabularyData({
    required this.wordEn,
    required this.wordVn,
    required this.exampleEn,
    required this.audioUrl,
  });

  factory VocabularyData.fromJson(Map<String, dynamic> json) {
    return VocabularyData(
      wordEn: json['class_name_en'] ?? '',
      wordVn: json['class_name_vn'] ?? '',
      exampleEn: json['example_sentence_en'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }
}
