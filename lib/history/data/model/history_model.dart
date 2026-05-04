class LearningHistory {
  final int historyId;
  final String objectNameEn;
  final String objectNameVn;
  final double confidence;
  final String sessionType;
  final DateTime timestamp;

  LearningHistory({
    required this.historyId,
    required this.objectNameEn,
    required this.objectNameVn,
    required this.confidence,
    required this.sessionType,
    required this.timestamp,
  });

  factory LearningHistory.fromJson(Map<String, dynamic> json) {
    return LearningHistory(
      historyId: json['history_id'] ?? 0,
      objectNameEn: json['object_name_en'] ?? '',
      objectNameVn: json['object_name_vn'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      sessionType: json['session_type'] ?? 'detection',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
