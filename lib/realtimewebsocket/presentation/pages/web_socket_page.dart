import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbl/core/constants/app_config.dart';
import '../../../routes.dart';
import '../widgets/color_widgets.dart';
import '../widgets/DetectionOverlay.dart';
import '../../data/repositories/web_socket_repository_impl.dart';
import '../../domain/repositories/i_web_socket_repository.dart';
import '../../data/models/detection_model.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();

  @override
  void initState() {
    super.initState();
    // Thay đổi IP cho đúng với máy tính của bạn
    _repository.connect(AppConfig.wsUrl);
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
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error}",
                style: TextStyle(color: Colors.white),
              ),
            );
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
                    // Vẽ khung nhận diện
                    DetectionOverlay(
                      detections: detections,
                      originalImageSize: const Size(320, 240),
                      onBoxTap: (label) {
                        print("Bạn đã chạm vào: $label");
                        Navigator.pushNamed(context, AppRoutes.vocabularyWebsocket);
                      },
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Danh sách đồ vật đã phát hiện",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[900],
                  child: ListView.builder(
                    itemCount: detections.length,
                    itemBuilder: (context, index) {
                      final item = detections[index];
                      final String label = item['class_name'] ?? 'Unknown';
                      final double confidence = (item['confidence'] ?? 0.0)
                          .toDouble();

                      return ListTile(
                        leading: Icon(
                          Icons.lens,
                          color: getColorForLabel(label),
                        ),
                        title: Text(
                          label.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "Độ tin cậy: ${(confidence * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          print("Bạn đã chạm vào: $label");
                          Navigator.pushNamed(context, AppRoutes.vocabularyWebsocket);
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
