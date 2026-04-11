import 'package:flutter/material.dart';
import '../../data/repositories/web_socket_repository_impl.dart';
import '../../domain/repositories/i_web_socket_repository.dart';

class WebSocketPage extends StatefulWidget {
  @override
  _WebSocketPageState createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  // Khởi tạo Repository (Trong thực tế nên dùng Dependency Injection như GetIt hoặc Provider)
  final IWebSocketRepository _repository = WebSocketRepositoryImpl();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Thay đổi URL phù hợp với FastAPI của bạn
    _repository.connect('ws://192.168.1.100:8000/api/v1/ws/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clean Arch WebSocket")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Gửi tin nhắn',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _repository.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _repository.messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}');
                  if (!snapshot.hasData)
                    return Center(child: Text("Đang chờ dữ liệu..."));

                  return ListView(
                    children: [
                      ListTile(
                        title: Text("Server phản hồi:"),
                        subtitle: Text("${snapshot.data}"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _repository.disconnect();
    _controller.dispose();
    super.dispose();
  }
}
