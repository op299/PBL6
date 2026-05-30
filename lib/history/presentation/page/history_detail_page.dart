import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/model/history_model.dart';
import '../../../realtimewebsocket/presentation/widgets/DetectionOverlay.dart';

class HistoryDetailPage extends StatelessWidget {
  final LearningHistory item;

  const HistoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      appBar: AppBar(
        title: Text("CHI TIẾT LỊCH SỬ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF66C457),
      ),
      body: Column(
        children: [
          // 1. Phần hiển thị ảnh có khoanh vùng
          AspectRatio(
            aspectRatio: 320 / 240,
            child: Stack(
              children: [
                // Hiển thị ảnh từ bộ nhớ
                Image.memory(
                  base64Decode(item.imageData!),
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                // Vẽ lại khung từ tọa độ đã lưu (box)
                DetectionOverlay(
                  detections: [
                    {
                      'class_name': item.objectNameEn,
                      'bbox': item.box, // Tọa độ lấy từ Database máy
                      'confidence': 1.0
                    }
                  ],
                  originalImageSize: const Size(320, 240),
                  onBoxTap: (l) {}, // Không cần bấm ở trang này
                ),
              ],
            ),
          ),
          
          // 2. Thông tin chi tiết bên dưới
          Padding(
            padding: EdgeInsets.all(40 * scale),
            child: Column(
              children: [
                Text(
                  item.objectNameEn.toUpperCase(),
                  style: TextStyle(fontSize: 60 * scale, fontWeight: FontWeight.bold, color: const Color(0xFF66C457)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.grey),
                  title: const Text("Thời gian học"),
                  subtitle: Text(item.timestamp.toString()),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: const Text("Ghi chú"),
                  subtitle: const Text("Vật thể được nhận diện tự động qua Camera."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}