import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbl/core/constants/app_config.dart';
import '../../../core/helpers/local_db_helper.dart';
import '../widgets/color_widgets.dart';
import '../widgets/DetectionOverlay.dart';
import '../../data/repositories/web_socket_repository_impl.dart';
import '../../domain/repositories/i_web_socket_repository.dart';
import '../../data/models/detection_model.dart';
import 'vocabulary_page.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();
  final LocalDbHelper _dbHelper = LocalDbHelper();
  
  bool _isStudyMode = false; // Trạng thái START/STOP từ ESP32/BE
  String? _lastSavedObject; // Để tránh lưu trùng lặp liên tục trong 1 giây

  @override
  void initState() {
    super.initState();
    _repository.connect(AppConfig.wsUrl);
  }

  // HÀM XỬ LÝ KHI NGƯỜI DÙNG CHỦ ĐỘNG NHẤN (Manual)
  void _handleManualSelection(String label, String imageBase64, List<dynamic> detections) async {
    print(" Người dùng chủ động chọn: $label");
    await _saveLocal(label, imageBase64, detections);
    _navigateToVocabulary(label);
  }

  // HÀM LƯU VÀO SQLITE (Dùng chung cho cả Tự động và Thủ công)
  Future<void> _saveLocal(String label, String imageBase64, List<dynamic> detections) async {
    if (kIsWeb) return;
    try {
      final det = detections.firstWhere(
        (d) => (d['class_name'] ?? d['label']) == label,
        orElse: () => {},
      );
      final List<dynamic> box = det['bbox'] ?? det['box'] ?? [0.0, 0.0, 0.0, 0.0];
      final double confidence = (det['confidence'] ?? 0.0).toDouble();

      await _dbHelper.saveToHistory(label, imageBase64, box, confidence);
      print(" Đã lưu vào lịch sử máy: $label");
    } catch (e) {
      print(" Lỗi lưu DB: $e");
    }
  }

  void _navigateToVocabulary(String label) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VocabularyPage(word: label)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isStudyMode ? "STUDY MODE (START)" : "PREVIEW MODE (STOP)"),
        backgroundColor: _isStudyMode ? Colors.green[800] : Colors.blueGrey[900],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _repository.messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final model = snapshot.data as DetectionModel;

          // 1. Cập nhật trạng thái STUDY/PREVIEW từ Backend
          if (_isStudyMode != model.studySessionActive) {
            Future.delayed(Duration.zero, () {
              setState(() => _isStudyMode = model.studySessionActive);
            });
          }

          // 2. TỰ ĐỘNG LƯU KHI BACKEND BÁO "SAVE READY"
          if (model.historySaveReady && model.stableObject != null) {
            final String stableLabel = model.stableObject!['label'];
            // Chỉ lưu nếu vật thể này khác vật thể vừa lưu trước đó (tránh loop)
            if (_lastSavedObject != stableLabel) {
              _lastSavedObject = stableLabel;
              _saveLocal(stableLabel, model.image!, model.detections);
              
              // Hiện thông báo nhỏ cho người dùng
              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" Tự động lưu: ${stableLabel.toUpperCase()}"),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 1),
                  ),
                );
              });
            }
          }

          // TRƯỜNG HỢP NHẬN TIN NHẮN STATUS (Nút bấm START/STOP)
          if (model.type == "study_session_status") {
            return _buildStatusOverlay(model.studySessionActive);
          }

          final imageBytes = model.image != null ? base64Decode(model.image!) : null;

          return Column(
            children: [
              // KHU VỰC CAMERA
              AspectRatio(
                aspectRatio: 320 / 240,
                child: Stack(
                  children: [
                    if (imageBytes != null)
                      Image.memory(imageBytes, width: double.infinity, fit: BoxFit.contain, gaplessPlayback: true),

                    // CHỈ HIỆN KHUNG KHI Ở CHẾ ĐỘ STUDY
                    if (_isStudyMode && model.detections.isNotEmpty)
                      DetectionOverlay(
                        detections: model.detections,
                        originalImageSize: const Size(320, 240),
                        onBoxTap: (label) => _handleManualSelection(label, model.image!, model.detections),
                      ),

                    // Nhãn chế độ trên màn hình
                    Positioned(
                      top: 10, left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isStudyMode ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(_isStudyMode ? "STUDYING" : "STOPPED", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              // THANH THEO DÕI ĐỘ ỔN ĐỊNH (TRACKING BAR)
              if (_isStudyMode && model.stableObject != null)
                _buildTrackingBar(model.stableObject!),

              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("DANH SÁCH NHẬN DIỆN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),

              // DANH SÁCH VẬT THỂ
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: model.detections.isEmpty
                      ? const Center(child: Text("Đang tìm vật thể...", style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: model.detections.length,
                          itemBuilder: (context, index) {
                            final item = model.detections[index];
                            final String label = item['class_name'] ?? 'Unknown';
                            final String nameVn = item['name_vn'] ?? '';
                            
                            return ListTile(
                              leading: Icon(Icons.lens, color: getColorForLabel(label)),
                              title: Text("$label ($nameVn)".toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text("Độ tin cậy: ${(item['confidence'] * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.grey)),
                              onTap: _isStudyMode ? () => _handleManualSelection(label, model.image!, model.detections) : null,
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

  Widget _buildTrackingBar(Map<String, dynamic> stable) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.orange.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Text(
            "Phân tích: ${stable['label']} (${stable['count']}/10)",
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          if (stable['stable'] == true) 
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.check_circle, color: Colors.green, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusOverlay(bool active) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(active ? Icons.play_circle : Icons.pause_circle, size: 80, color: active ? Colors.green : Colors.red),
          const SizedBox(height: 20),
          Text(active ? "CHẾ ĐỘ HỌC ĐÃ BẬT" : "ĐÃ TẮT CHẾ ĐỘ HỌC", style: TextStyle(color: active ? Colors.green : Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _repository.disconnect();
    super.dispose();
  }
}