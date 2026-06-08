import 'dart:convert';
import 'dart:typed_data';
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
import 'dart:async';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();
  final LocalDbHelper _dbHelper = LocalDbHelper();
  StreamSubscription? _subscription;

  bool _isStudyMode = false;
  String? _lastSavedObject;
  Uint8List? _lastFrame;
  DetectionModel? _currentModel;

  @override
  void initState() {
    super.initState();
    _repository.connect(AppConfig.wsUrl);

    _subscription = _repository.messages.listen((data) {
      final model = data as DetectionModel;
      _handleIncomingData(model);
    });
  }

  void _handleIncomingData(DetectionModel model) {
    if (!mounted) return;

    setState(() {
      _currentModel = model;

      if (model.image != null && model.image!.isNotEmpty) {
        try {
          _lastFrame = base64Decode(model.image!);
        } catch (e) {
          print("Lỗi decode ảnh: $e");
        }
      }

      if (_isStudyMode != model.studySessionActive) {
        _isStudyMode = model.studySessionActive;
        _showStatusSnackBar(_isStudyMode);
      }

      if (model.historySaveReady &&
          model.stableObject != null &&
          model.image != null) {
        _handleAutoSave(model);
      }
    });
  }

  void _showStatusSnackBar(bool active) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(active ? " CHẾ ĐỘ HỌC ĐÃ BẬT" : " ĐÃ DỪNG PHIÊN HỌC"),
        backgroundColor: active ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAutoSave(DetectionModel model) async {
    final String stableLabel = model.stableObject!['label'];
    if (_lastSavedObject != stableLabel) {
      _lastSavedObject = stableLabel;
      await _saveLocal(stableLabel, model.image!, model.detections);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" TỰ ĐỘNG LƯU: ${stableLabel.toUpperCase()}"),
            backgroundColor: Colors.blueAccent,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
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
      final String nameVn = det['name_vn'] ?? det['class_name_vn'] ?? '';

      await _dbHelper.saveToHistory(
        name: label,
        vnName: nameVn,
        base64Image: imageBase64,
        box: box,
        confidence: confidence,
      );
    } catch (e) {
      print("Lỗi lưu: $e");
    }
  }

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
    if (_currentModel == null && _lastFrame == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isStudyMode ? "STUDY MODE" : "PREVIEW MODE"),
        backgroundColor: _isStudyMode
            ? Colors.green[800]
            : Colors.blueGrey[900],
        centerTitle: true,
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 320 / 240,
            child: Stack(
              children: [
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

                if (_isStudyMode &&
                    _currentModel != null &&
                    _currentModel!.detections.isNotEmpty)
                  DetectionOverlay(
                    detections: _currentModel!.detections,
                    originalImageSize: const Size(320, 240),
                    onBoxTap: (label) => _handleManualSelection(
                      label,
                      _currentModel!.image ?? '',
                      _currentModel!.detections,
                    ),
                  ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isStudyMode ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
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

          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "VẬT THỂ NHẬN DIỆN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.grey[900],
              child:
                  (_currentModel == null || _currentModel!.detections.isEmpty)
                  ? const Center(
                      child: Text(
                        "Không có dữ liệu",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _currentModel!.detections.length,
                      itemBuilder: (context, index) {
                        final item = _currentModel!.detections[index];
                        final label = item['class_name'] ?? 'Unknown';
                        final vnName = item['name_vn'] ?? '';
                        return ListTile(
                          leading: Icon(
                            Icons.lens,
                            color: getColorForLabel(label),
                          ),
                          title: Text(
                            "${label.toUpperCase()} ($vnName)",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Confidence: ${(item['confidence'] * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: _isStudyMode
                              ? () => _handleManualSelection(
                                  label,
                                  _currentModel!.image ?? '',
                                  _currentModel!.detections,
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _repository.disconnect();
    super.dispose();
  }
}
