import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../realtimewebsocket/presentation/pages/vocabulary_page.dart';
import '../../../realtimewebsocket/presentation/widgets/DetectionOverlay.dart';
import '../../data/model/history_model.dart';


class HistoryDetailPage extends StatelessWidget {
  final LearningHistory item;

  const HistoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("CHI TIẾT NHẬN DIỆN"),
        backgroundColor: const Color(0xFF66C457),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. HIỂN THỊ ẢNH KÈM KHUNG KHOANH VÙNG
          AspectRatio(
            aspectRatio: 320 / 240,
            child: Stack(
              children: [
                if (item.imageData != null)
                  Image.memory(
                    base64Decode(item.imageData!),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                // Tái sử dụng Widget vẽ khung
                DetectionOverlay(
                  detections: [
                    {
                      'class_name': item.objectNameEn,
                      'bbox': item.box, // Tọa độ đã lưu trong Model
                      'confidence': item.confidence,
                      'name_vn': item.objectNameVn
                    }
                  ],
                  originalImageSize: const Size(320, 240),
                  onBoxTap: (l) {}, // Không cần bấm ở trang này
                ),
              ],
            ),
          ),

          // 2. THÔNG TIN CHI TIẾT
          Padding(
            padding: EdgeInsets.all(50 * scale),
            child: Column(
              children: [
                Text(
                  item.objectNameEn.toUpperCase(),
                  style: TextStyle(fontSize: 80 * scale, fontWeight: FontWeight.bold, color: const Color(0xFF4A4A4A)),
                ),
                Text(
                  item.objectNameVn,
                  style: TextStyle(fontSize: 50 * scale, color: const Color(0xFF66C457)),
                ),
                SizedBox(height: 40 * scale),
                const Divider(),
                _buildInfoRow(Icons.query_stats, "Độ tin cậy", "${(item.confidence * 100).toStringAsFixed(1)}%", scale),
                _buildInfoRow(Icons.access_time, "Thời gian", item.timestamp.toString(), scale),
                
                SizedBox(height: 60 * scale),

                // 3. NÚT NHẢY SANG TRANG VỪ VỰNG ĐỂ HỌC LẠI
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VocabularyPage(word: item.objectNameEn)));
                  },
                  icon: const Icon(Icons.menu_book, color: Colors.white),
                  label: Text("HỌC LẠI TỪ NÀY", style: TextStyle(fontSize: 35 * scale, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66C457),
                    padding: EdgeInsets.symmetric(horizontal: 80 * scale, vertical: 30 * scale),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50 * scale)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15 * scale),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 40 * scale),
          SizedBox(width: 20 * scale),
          Text("$label: ", style: TextStyle(fontSize: 30 * scale, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 30 * scale, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}