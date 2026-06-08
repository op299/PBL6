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
  List<LearningHistory> _allHistory = [];
  bool _isLoading = true;
  bool _isGrouped = false; 

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final List<Map<String, dynamic>> localData = await _dbHelper.getAllHistory();
      setState(() {
        _allHistory = localData
            .map((item) => LearningHistory.fromLocalMap(item))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(" Lỗi lấy dữ liệu local: $e");
      setState(() => _isLoading = false);
    }
  }

  // LOGIC GỘP CÁC TỪ TRÙNG TRONG NGÀY
  List<LearningHistory> get _displayList {
    if (!_isGrouped) return _allHistory;

    final Map<String, LearningHistory> groupedMap = {};
    for (var item in _allHistory) {
      // Gộp theo Ngày + Tên tiếng Anh
      String dayKey = DateFormat('yyyy-MM-dd').format(item.timestamp);
      String uniqueKey = "${dayKey}_${item.objectNameEn}";

      if (!groupedMap.containsKey(uniqueKey)) {
        groupedMap[uniqueKey] = item;
      }
    }
    return groupedMap.values.toList();
  }

  void _deleteItem(int id) async {
    await _dbHelper.deleteHistory(id);
    _loadHistory(); 
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Đã xóa mục lịch sử"), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double scale = screenWidth / 1080;
    final list = _displayList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "HISTORY",
          style: TextStyle(color: const Color(0xFF66C457), fontWeight: FontWeight.bold, fontSize: 45 * scale),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isGrouped ? Icons.grid_view_rounded : Icons.reorder_rounded,
              color: const Color(0xFF66C457),
            ),
            onPressed: () => setState(() => _isGrouped = !_isGrouped),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF66C457), size: 40 * scale),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFEAF0EA)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadHistory,
          color: const Color(0xFF66C457),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF66C457)))
              : list.isEmpty
                  ? ListView(children: [SizedBox(height: 300 * scale), const Center(child: Text("Lịch sử trống"))])
                  : ListView.builder(
                      padding: EdgeInsets.all(40 * scale),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final String formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(item.timestamp);

                        return Dismissible(
                          key: Key(item.historyId.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(30 * scale)),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) => _deleteItem(item.historyId),
                          child: GestureDetector(
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
                                        ? Image.memory(base64Decode(item.imageData!),
                                            width: 200 * scale, height: 200 * scale, fit: BoxFit.cover)
                                        : Container(width: 200 * scale, height: 200 * scale, color: Colors.grey[200], child: const Icon(Icons.image)),
                                  ),
                                  SizedBox(width: 40 * scale),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.objectNameEn.toUpperCase(),
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40 * scale)),
                                        // HIỂN THỊ NGHĨA TIẾNG VIỆT
                                        Text(
                                          item.objectNameVn.isNotEmpty ? "Nghĩa: ${item.objectNameVn}" : "Chưa có nghĩa",
                                          style: TextStyle(fontSize: 30 * scale, color: const Color(0xFF66C457)),
                                        ),
                                        Text(formattedTime, style: TextStyle(fontSize: 24 * scale, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => _deleteItem(item.historyId),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}