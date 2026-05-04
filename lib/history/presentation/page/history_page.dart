import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../core/constants/app_config.dart';
import '../../data/model/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  
  Future<List<LearningHistory>> _fetchHistory() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.historyUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        final List<dynamic> listData = decodedData['history'] ?? [];

        return listData.map((item) => LearningHistory.fromJson(item)).toList();
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
        title: Text(
          "HISTORY",
          style: TextStyle(
            color: const Color(0xFF66C457),
            fontWeight: FontWeight.bold,
            fontSize: 40 * scale,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF66C457)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFEAF0EA)],
          ),
        ),
        child: FutureBuilder<List<LearningHistory>>(
          future: _fetchHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF66C457)),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Lỗi: ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final historyList = snapshot.data ?? [];

            if (historyList.isEmpty) {
              return const Center(child: Text("Bạn chưa có lịch sử học tập."));
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 40 * scale,
                vertical: 20 * scale,
              ),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 30 * scale),
                  padding: EdgeInsets.all(35 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50 * scale,
                        backgroundColor: const Color(
                          0xFF66C457,
                        ).withOpacity(0.1),
                        child: Icon(
                          item.sessionType == 'detection'
                              ? Icons.camera_alt_rounded
                              : Icons.quiz_rounded,
                          color: const Color(0xFF66C457),
                          size: 50 * scale,
                        ),
                      ),
                      SizedBox(width: 40 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.objectNameEn.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 38 * scale,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5 * scale),
                            Text(
                              "Nghĩa: ${item.objectNameVn}",
                              style: TextStyle(
                                fontSize: 30 * scale,
                                color: const Color(0xFF66C457),
                              ),
                            ),
                            Text(
                              "Độ tin cậy: ${(item.confidence * 100).toStringAsFixed(0)}% • ${DateFormat('HH:mm dd/MM').format(item.timestamp)}",
                              style: TextStyle(
                                fontSize: 26 * scale,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35 * scale,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
