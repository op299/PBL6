import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 320 / 240,
              child: Stack(
                children: [
                  if (item.imageData != null && item.imageData!.isNotEmpty)
                    Image.memory(
                      base64Decode(item.imageData!),
                      width: double.infinity,
                      fit: BoxFit.contain,
                    )
                  else
                    Container(
                      color: Colors.black12,
                      child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
                    ),
                  DetectionOverlay(
                    detections: [
                      {
                        'class_name': item.objectNameEn,
                        'bbox': item.box, 
                        'confidence': item.confidence,
                        'name_vn': item.objectNameVn
                      }
                    ],
                    originalImageSize: const Size(320, 240),
                    onBoxTap: (l) {}, 
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(50 * scale),
              child: Column(
                children: [
                  Text(
                    item.objectNameEn.toUpperCase(),
                    style: TextStyle(
                      fontSize: 80 * scale,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  Text(
                    item.objectNameVn.isNotEmpty ? item.objectNameVn : "Chưa có nghĩa",
                    style: TextStyle(
                      fontSize: 50 * scale,
                      color: const Color(0xFF66C457),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 40 * scale),
                  const Divider(),

                  _buildInfoRow(Icons.query_stats, "Độ tin cậy", "${(item.confidence * 100).toStringAsFixed(1)}%", scale),
                  _buildInfoRow(
                    Icons.access_time, 
                    "Thời gian học", 
                    DateFormat('HH:mm - dd/MM/yyyy').format(item.timestamp), 
                    scale
                  ),
                  
                  SizedBox(height: 80 * scale),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VocabularyPage(word: item.objectNameEn),
                        ),
                      );
                    },
                    icon: Icon(Icons.menu_book, color: Colors.white, size: 40 * scale),
                    label: Text(
                      "HỌC LẠI TỪ NÀY",
                      style: TextStyle(fontSize: 35 * scale, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66C457),
                      elevation: 5,
                      padding: EdgeInsets.symmetric(horizontal: 100 * scale, vertical: 30 * scale),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50 * scale),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Bấm để xem lại nghĩa chi tiết và phát âm",
                    style: TextStyle(color: Colors.grey, fontSize: 24 * scale),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20 * scale),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF66C457), size: 45 * scale),
          SizedBox(width: 25 * scale),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 32 * scale, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 32 * scale, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}