import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/DetectionOverlay.dart';
import '../../data/repositories/web_socket_repository_impl.dart';
import '../../domain/repositories/i_web_socket_repository.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _repository.connect('ws://192.168.1.103:8000/api/v1/ws/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Real-time Object Detection")),
      body: StreamBuilder(
        stream: _repository.messages,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final data = jsonDecode(snapshot.data);
          final imageBytes = base64Decode(data['image']);
          final detections = data['detections'] as List<dynamic>;

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
                    DetectionOverlay(
                      detections: detections,
                      originalImageSize: const Size(320, 240),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Logs", style: TextStyle(color: Colors.white)),
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
