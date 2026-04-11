class DetectionModel {
  final String image;
  final List<dynamic> detections;

  DetectionModel({required this.image, required this.detections});

  // Hàm này chính là cái "phễu" để hứng JSON
  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      image: json['image'] ?? '',
      detections: json['detections'] ?? [],
    );
  }
}
