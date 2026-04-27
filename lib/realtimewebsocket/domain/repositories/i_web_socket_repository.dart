abstract class IWebSocketRepository {
  // Luồng dữ liệu nhận về từ Server
  Stream<dynamic> get messages;

  // Các hành động
  void connect(String url);
  void sendMessage(String message);
  void disconnect();
}