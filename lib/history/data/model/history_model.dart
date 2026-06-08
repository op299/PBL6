import 'dart:convert';

class LearningHistory {
  final int historyId;
  final String objectNameEn;
  final String objectNameVn;
  final double confidence;
  final String sessionType;
  final DateTime timestamp;
  final String? imageData; 
  final List<double> box; 
  LearningHistory({
    required this.historyId,
    required this.objectNameEn,
    required this.objectNameVn,
    required this.confidence,
    required this.sessionType,
    required this.timestamp,
    this.imageData,
    required this.box,
  });

  factory LearningHistory.fromJson(Map<String, dynamic> json) {
    return LearningHistory(
      historyId: json['history_id'] ?? 0,
      objectNameEn: json['object_name_en'] ?? '',
      objectNameVn: json['object_name_vn'] ?? '',
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      sessionType: json['session_type'] ?? 'detection',
      imageData: json['image_data'],
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      box: (json['box'] as List? ?? [0.0, 0.0, 0.0, 0.0])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  factory LearningHistory.fromLocalMap(Map<String, dynamic> map) {
    return LearningHistory(
      historyId: map['id'] ?? 0,
      objectNameEn: map['object_name'] ?? 'Unknown',
      objectNameVn: map['object_name_vn']  ?? '',
      confidence: (map['confidence'] as num? ?? 0.0).toDouble(),
      sessionType: 'detection',
      imageData: map['image_data'],
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      box: (jsonDecode(map['box_data'] ?? '[0.0, 0.0, 0.0, 0.0]') as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
