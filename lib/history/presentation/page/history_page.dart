import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/helpers/local_db_helper.dart';
import '../../data/model/history_model.dart';
import 'history_detail_page.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final LocalDbHelper _dbHelper = LocalDbHelper();

  Future<List<LearningHistory>> _fetchLocalHistory() async {
    try {
      final List<Map<String, dynamic>> localData = await _dbHelper
          .getAllHistory();
      return localData
          .map((item) => LearningHistory.fromLocalMap(item))
          .toList();
    } catch (e) {
      debugPrint("Lỗi lấy dữ liệu local: $e");
      return [];
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
            fontSize: 45 * scale,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF66C457),
            size: 40 * scale,
          ),
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
          future: _fetchLocalHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF66C457)),
              );
            }

            final historyList = snapshot.data ?? [];

            if (historyList.isEmpty) {
              return Center(
                child: Text(
                  "Bạn chưa có lịch sử học tập nào.",
                  style: TextStyle(fontSize: 35 * scale, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 40 * scale,
                vertical: 20 * scale,
              ),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                final String formattedTime = DateFormat(
                  'HH:mm - dd/MM/yyyy',
                ).format(item.timestamp);

                // BỌC TRONG GESTURE DETECTOR ĐỂ NHẤN ĐƯỢC
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailPage(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30 * scale),
                    padding: EdgeInsets.all(30 * scale),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20 * scale),
                          child:
                              item.imageData != null &&
                                  item.imageData!.isNotEmpty
                              ? Image.memory(
                                  base64Decode(item.imageData!),
                                  width: 180 * scale,
                                  height: 180 * scale,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 180 * scale,
                                  height: 180 * scale,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 60 * scale,
                                  ),
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
                                  fontSize: 40 * scale,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10 * scale),
                              Text(
                                "Ngày học: $formattedTime",
                                style: TextStyle(
                                  fontSize: 26 * scale,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "Xem chi tiết khoanh vùng >",
                                style: TextStyle(
                                  fontSize: 24 * scale,
                                  color: const Color(0xFF66C457),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
