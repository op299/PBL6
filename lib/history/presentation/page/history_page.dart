import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Đừng quên thêm 'intl' vào pubspec.yaml
import 'package:pbl/history/data/model/history_model.dart';
import '../../../core/constants/app_config.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<LearningHistory>> _fetchHistory() async {
    final url = AppConfig.historyUrl; 
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonData.map((item) => LearningHistory.fromJson(item)).toList();
      } else {
        throw Exception("Lỗi Server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Không thể tải lịch sử: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      appBar: AppBar(
        title: Text("HISTORY", style: TextStyle(color: Color(0xFF66C457), fontWeight: FontWeight.bold, fontSize: 40 * scale)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF66C457)),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: FutureBuilder<List<LearningHistory>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF66C457)));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Lịch sử trống rỗng."));
          }
          final List<LearningHistory> historyList = snapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFEAF0EA)],
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(30 * scale),
              itemCount: historyList.length, 
              itemBuilder: (context, index) {
                final item = historyList[index]; 
                
                return Container(
                  margin: EdgeInsets.only(bottom: 25 * scale),
                  padding: EdgeInsets.all(30 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30 * scale),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF66C457).withOpacity(0.1),
                        child: Icon(
                          item.sessionType == 'detection' ? Icons.camera_alt : Icons.quiz, 
                          color: Color(0xFF66C457)
                        ),
                      ),
                      SizedBox(width: 30 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          
                            Text(item.objectNameEn.toUpperCase(), 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35 * scale)),
                            Text(
                              "Nghĩa: ${item.objectNameVn} (${(item.confidence * 100).toStringAsFixed(1)}%)", 
                              style: TextStyle(color: Colors.grey, fontSize: 25 * scale)
                            ),
                            Text(
                              DateFormat('HH:mm - dd/MM/yyyy').format(item.timestamp), 
                              style: TextStyle(color: Colors.blueGrey, fontSize: 22 * scale)
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 30 * scale, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}