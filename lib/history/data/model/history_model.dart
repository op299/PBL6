import 'dart:convert';

class LearningHistory {
  final int historyId;
  final String objectNameEn;
  final String objectNameVn;
  final double confidence;
  final String sessionType;
  final DateTime timestamp;
  final String? imageData; // Lưu chuỗi Base64 của ảnh
  final List<double> box; // Tọa độ [x1, y1, x2, y2]

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

  // 1. DÙNG CHO DỮ LIỆU TỪ BACKEND (API)
  factory LearningHistory.fromJson(Map<String, dynamic> json) {
    return LearningHistory(
      historyId: json['history_id'] ?? 0,
      objectNameEn: json['object_name_en'] ?? '',
      objectNameVn: json['object_name_vn'] ?? '',
      // Ép kiểu num sang double để tránh lỗi số nguyên (ví dụ: 1 -> 1.0)
      confidence: (json['confidence'] as num? ?? 0.0).toDouble(),
      sessionType: json['session_type'] ?? 'detection',
      // Lấy ảnh từ BE (nếu BE có trả về trường image_data)
      imageData: json['image_data'],
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      // Ép kiểu an toàn cho danh sách tọa độ
      box: (json['box'] as List? ?? [0.0, 0.0, 0.0, 0.0])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  // 2. DÙNG CHO DỮ LIỆU TỪ MÁY ĐIỆN THOẠI (SQLITE)
  factory LearningHistory.fromLocalMap(Map<String, dynamic> map) {
    return LearningHistory(
      historyId: map['id'] ?? 0,
      objectNameEn: map['object_name'] ?? 'Unknown',
      objectNameVn: '', // Local SQLite thường không lưu nghĩa tiếng Việt
      confidence: (map['confidence'] as num? ?? 0.0).toDouble(),
      sessionType: 'detection',
      imageData: map['image_data'],
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      // Vì SQLite lưu List dưới dạng chuỗi String, nên phải jsonDecode
      box: (jsonDecode(map['box_data'] ?? '[0.0, 0.0, 0.0, 0.0]') as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
