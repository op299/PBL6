class DetectionModel {
  final String type;
  final bool studySessionActive;
  final bool historySaveReady;
  final String? image;
  final String? mode;
  final List<dynamic> detections;
  final Map<String, dynamic>? stableObject;

  DetectionModel({
    required this.type,
    required this.studySessionActive,
    required this.historySaveReady,
    this.image,
    this.mode,
    this.detections = const [],
    this.stableObject,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      type: json['type'] ?? '',
      studySessionActive: json['study_session_active'] ?? false,
      historySaveReady: json['history_save_ready'] ?? false,
      image: json['image'],
      mode: json['mode'],
      detections: json['detections'] ?? [],
      stableObject: json['stable_object'],
    );
  }
}
