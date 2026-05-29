import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Thêm dòng này để kiểm tra Web
import 'package:pbl/core/constants/app_config.dart';
import '../widgets/color_widgets.dart';
import '../widgets/DetectionOverlay.dart';
import '../../data/repositories/web_socket_repository_impl.dart';
import '../../domain/repositories/i_web_socket_repository.dart';
import '../../data/models/detection_model.dart';
import 'vocabulary_page.dart';
import '../../../core/helpers/local_db_helper.dart'; 

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();
  // KHỞI TẠO HELPER ĐỂ LƯU ẢNH VÀ LỊCH SỬ
  final LocalDbHelper _dbHelper = LocalDbHelper();

  @override
  void initState() {
    super.initState();
    _repository.connect(AppConfig.wsUrl);
  }

  // HÀM XỬ LÝ LƯU VÀ CHUYỂN TRANG
  void _handleSelection(String label, String imageBase64) async {
    print("Đang xử lý vật thể: $label");

    // 1. CHỤP ẢNH & LƯU LẠI
    try {
      // sqflite không hỗ trợ Web, nên chỉ chạy khi là Mobile (Android/iOS)
      if (!kIsWeb) {
        await _dbHelper.saveToHistory(label, imageBase64);
        print("Đã lưu lịch sử vào điện thoại.");
      } else {
        print("Chế độ Web: Bỏ qua việc lưu Database (sqflite không hỗ trợ Web).");
      }
    } catch (e) {
      // Nếu có lỗi ở Database (như trên Web), in lỗi ra nhưng VẪN CHẠY TIẾP để chuyển trang
      print("Lỗi Database: $e");
    }
    
    // 2. CHUYỂN TRANG (Lệnh này bây giờ chắc chắn sẽ được chạy)
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VocabularyPage(word: label),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Real-time Object Detection"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: StreamBuilder(
        stream: _repository.messages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}", style: TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final model = snapshot.data as DetectionModel;
          final imageBytes = base64Decode(model.image);
          final detections = model.detections;

          return Column(
            children: [
              AspectRatio(
                aspectRatio: 320 / 240,
                child: Stack(
                  children: [
                    Image.memory(
                      imageBytes,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    ),
                    // KHI BẤM VÀO Ô VUÔNG TRÊN ẢNH
                    DetectionOverlay(
                      detections: detections,
                      originalImageSize: const Size(320, 240),
                      onBoxTap: (label) {
                        _handleSelection(label, model.image);
                      },
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Danh sách đồ vật đã phát hiện",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: ListView.builder(
                    itemCount: detections.length,
                    itemBuilder: (context, index) {
                      final item = detections[index];
                      // Sửa lại class_name cho khớp với BE của bạn
                      final String label = item['class_name'] ?? 'Unknown';
                      final double confidence = (item['confidence'] ?? 0.0).toDouble();

                      return ListTile(
                        leading: Icon(Icons.lens, color: getColorForLabel(label)),
                        title: Text(
                          label.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Độ tin cậy: ${(confidence * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.history, color: Colors.blueGrey, size: 18),
                        onTap: () {
                          _handleSelection(label, model.image);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _repository.disconnect();
    super.dispose();
  }
}