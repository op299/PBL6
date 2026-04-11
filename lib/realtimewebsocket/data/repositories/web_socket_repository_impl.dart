import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../domain/repositories/i_web_socket_repository.dart';
import '../models/detection_model.dart';

class WebSocketRepositoryImpl implements IWebSocketRepository {
  WebSocketChannel? _channel;

  @override
  void connect(String url) {
    try {
      print("Đang thử kết nối tới: $url");
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print("DEBUG: URL đang kết nối là: '$url'"); // Thêm dòng này
      _channel!.ready
          .then((_) {
            print("Kết nối thành công!");
          })
          .catchError((e) {
            print("Lỗi kết nối WebSocket: $e");
          });
    } catch (e) {
      print("Không thể khởi tạo kết nối: $e");
    }
  }

  @override
  Stream<DetectionModel> get messages {
    return _channel!.stream.map((rawString) {
      final Map<String, dynamic> json = jsonDecode(rawString);
      return DetectionModel.fromJson(
        json,
      ); 
    });
  }

  @override
  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  @override
  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _channel = null;
  }
}
