import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

import '../../../core/constants/app_config.dart';
import '../../data/models/vocabulary_model.dart';

class VocabularyPage extends StatefulWidget {
  final String word;

  const VocabularyPage({Key? key, required this.word}) : super(key: key);

  @override
  _VocabularyPageState createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VocabularyData? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.getVocabularyUrl(widget.word)),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        final parsedData = VocabularyData.fromJson(decodedData);

        setState(() {
          _data = parsedData;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Lỗi: $e");
      setState(() => _isLoading = false);
    }
  }

  void _playAudio() async {
    if (_data == null || _data!.audioUrl.isEmpty) return;

    final fullAudioUrl = AppConfig.getAudioUrl(_data!.audioUrl);

    await _audioPlayer.play(UrlSource(fullAudioUrl));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Học từ vựng")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_data == null) {
      return Scaffold(
        body: Center(
          child: Text("Không tìm thấy dữ liệu cho từ '${widget.word}'"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text("Học từ vựng")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Tiếng Anh
                  Text(
                    _data?.wordEn ?? ''
                      ..toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Phiên âm: ${_data?.pronunciation ?? ''}",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "Nghĩa: ${_data!.wordVn}",
                    style: TextStyle(fontSize: 24, color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 30),

                  // 3. Nút Loa
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        size: 80,
                        color: Colors.orange,
                      ),
                      onPressed: _playAudio,
                    ),
                  ),
                  const Center(child: Text("Bấm để nghe phát âm")),

                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _data!.exampleEn,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
