import 'dart:convert';
import 'dart:typed_data'; // Cần thiết để xử lý mảng byte ảnh
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

  bool _isStudyMode = false;
  String? _lastSavedObject;
  Uint8List? _lastFrame; // LƯU KHUNG HÌNH CUỐI CÙNG ĐỂ CHỐNG ĐEN MÀN HÌNH

  @override
  void initState() {
    super.initState();
    _repository.connect(AppConfig.wsUrl);
  }

  Future<void> _saveLocal(
    String label,
    String imageBase64,
    List<dynamic> detections,
  ) async {
    if (kIsWeb) return;
    try {
      final det = detections.firstWhere(
        (d) => (d['class_name'] ?? d['label']) == label,
        orElse: () => {},
      );
      if (det.isEmpty) return;

      final List<dynamic> box =
          det['bbox'] ?? det['box'] ?? [0.0, 0.0, 0.0, 0.0];
      final double confidence = (det['confidence'] ?? 0.0).toDouble();
      final String nameVn = det['name_vn'] ?? ''; // Lấy tên tiếng Việt từ BE
      await _dbHelper.saveToHistory(
        name: label,
        vnName: nameVn,
        base64Image: imageBase64,
        box: box,
        confidence: confidence,
      );
    } catch (e) {
      print(" Lỗi lưu DB: $e");
    }
  }

  // HÀM XỬ LÝ KHI NGƯỜI DÙNG NHẤN THỦ CÔNG
  void _handleManualSelection(
    String label,
    String imageBase64,
    List<dynamic> detections,
  ) async {
    await _saveLocal(label, imageBase64, detections);
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
        title: Text(
          _isStudyMode ? "STUDY MODE (START)" : "PREVIEW MODE (STOP)",
        ),
        backgroundColor: _isStudyMode
            ? Colors.green[800]
            : Colors.blueGrey[900],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _repository.messages,
        builder: (context, snapshot) {
          // Nếu chưa bao giờ có dữ liệu và cũng chưa có frame nào trong bộ nhớ đệm
          if (!snapshot.hasData && _lastFrame == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final model = snapshot.data as DetectionModel;

          // 1. CẬP NHẬT TRẠNG THÁI START/STOP
          if (_isStudyMode != model.studySessionActive) {
            _isStudyMode = model.studySessionActive;
            Future.delayed(Duration.zero, () {
              setState(() {}); // Để đổi màu AppBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isStudyMode ? " CHẾ ĐỘ HỌC ĐÃ BẬT" : " ĐÃ DỪNG PHIÊN HỌC",
                  ),
                  backgroundColor: _isStudyMode ? Colors.green : Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          }

          // 2. TỰ ĐỘNG LƯU KHI BACKEND BÁO "SAVE READY"
          if (model.historySaveReady &&
              model.stableObject != null &&
              model.image != null) {
            final String stableLabel = model.stableObject!['label'];
            if (_lastSavedObject != stableLabel) {
              _lastSavedObject = stableLabel;
              _saveLocal(stableLabel, model.image!, model.detections);

              Future.delayed(Duration.zero, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(" TỰ ĐỘNG LƯU: ${stableLabel.toUpperCase()}"),
                    backgroundColor: Colors.blueAccent,
                  ),
                );
              });
            }
          }

          // 3. CẬP NHẬT BỘ NHỚ ĐỆM HÌNH ẢNH
          if (model.image != null) {
            _lastFrame = base64Decode(model.image!);
          }

          return Column(
            children: [
              AspectRatio(
                aspectRatio: 320 / 240,
                child: Stack(
                  children: [
                    // Hiển thị ảnh: Ưu tiên ảnh mới, nếu không có dùng ảnh cũ (_lastFrame)
                    if (_lastFrame != null)
                      Image.memory(
                        _lastFrame!,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                      )
                    else
                      const Center(
                        child: Text(
                          "Đang chờ hình ảnh...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    // Vẽ khung Bbox
                    if (_isStudyMode && model.detections.isNotEmpty)
                      DetectionOverlay(
                        detections: model.detections,
                        originalImageSize: const Size(320, 240),
                        onBoxTap: (label) => _handleManualSelection(
                          label,
                          model.image ?? '',
                          model.detections,
                        ),
                      ),

                    // Nhãn trạng thái góc màn hình
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        color: _isStudyMode ? Colors.green : Colors.red,
                        child: Text(
                          _isStudyMode ? "STUDYING" : "STOPPED",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Thanh Tracking
              if (_isStudyMode && model.stableObject != null)
                _buildTrackingBar(model.stableObject!),

              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "VẬT THỂ NHẬN DIỆN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Danh sách vật thể
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: model.detections.isEmpty
                      ? const Center(
                          child: Text(
                            "Không có dữ liệu",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: model.detections.length,
                          itemBuilder: (context, index) {
                            final item = model.detections[index];
                            final label = item['class_name'] ?? 'Unknown';
                            final vnName = item['name_vn'] ?? '';
                            return ListTile(
                              leading: Icon(
                                Icons.lens,
                                color: getColorForLabel(label),
                              ),
                              title: Text(
                                "$label ($vnName)".toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "Confidence: ${(item['confidence'] * 100).toStringAsFixed(1)}%",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              onTap: _isStudyMode
                                  ? () => _handleManualSelection(
                                      label,
                                      model.image ?? '',
                                      model.detections,
                                    )
                                  : null,
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
          const Icon(Icons.analytics_outlined, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Text(
            "Phân tích: ${stable['label']} (${stable['count']}/10)",
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (stable['stable'] == true)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.verified, color: Colors.green, size: 18),
            ),
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
