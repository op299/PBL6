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
  late Future<List<LearningHistory>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistoryFromLocal();
  }

  Future<List<LearningHistory>> _fetchHistoryFromLocal() async {
    try {
      final List<Map<String, dynamic>> localData = await _dbHelper.getAllHistory();
      return localData.map((item) => LearningHistory.fromLocalMap(item)).toList();
    } catch (e) {
      debugPrint(" Lỗi lấy lịch sử local: $e");
      return [];
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _historyFuture = _fetchHistoryFromLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;

    return Scaffold(
      backgroundColor: Colors.white,
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
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF66C457), size: 40 * scale),
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
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xFF66C457),
          child: FutureBuilder<List<LearningHistory>>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF66C457)));
              }
              
              final list = snapshot.data ?? [];
              if (list.isEmpty) {
                return ListView(
                  children: [
                    SizedBox(height: 300 * scale),
                    const Center(child: Text("Chưa có lịch sử. Hãy quét vật thể ở Study Mode!")),
                  ],
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(40 * scale),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final String formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(item.timestamp);

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryDetailPage(item: item)),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 35 * scale),
                      padding: EdgeInsets.all(30 * scale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30 * scale),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20 * scale),
                            child: item.imageData != null && item.imageData!.isNotEmpty
                                ? Image.memory(
                                    base64Decode(item.imageData!),
                                    width: 200 * scale,
                                    height: 200 * scale,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 200 * scale,
                                    height: 200 * scale,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image, color: Colors.grey, size: 60 * scale),
                                  ),
                          ),
                          SizedBox(width: 40 * scale),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.objectNameEn.toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40 * scale),
                                ),
                                Text(
                                  "Nghĩa: ${item.objectNameVn.isNotEmpty ? item.objectNameVn : 'Chưa có'}",
                                  style: TextStyle(fontSize: 30 * scale, color: const Color(0xFF66C457)),
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(fontSize: 24 * scale, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30 * scale, color: Colors.grey[300]),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}