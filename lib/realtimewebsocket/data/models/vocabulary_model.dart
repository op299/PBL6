class VocabularyData {
  final String wordEn;
  final String wordVn;
  final String exampleEn;
  final String pronunciation;
  final String audioUrl;

  VocabularyData({
    required this.wordEn,
    required this.wordVn,
    required this.exampleEn,
    required this.pronunciation,
    required this.audioUrl,
  });

  factory VocabularyData.fromJson(Map<String, dynamic> json) {
    return VocabularyData(
      wordEn: json['class_name_en']?.toString() ?? '',
      wordVn: json['class_name_vn']?.toString() ?? '',
      exampleEn: json['example_sentence_en']?.toString() ?? '',
      audioUrl: json['audio_url']?.toString() ?? '',
      pronunciation: json['pronunciation_en']?.toString() ?? '',
    );
  }
}
