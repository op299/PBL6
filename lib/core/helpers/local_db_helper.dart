import 'dart:convert'; // Thêm thư viện này để dùng jsonEncode
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  _initDb() async {
    String path = join(await getDatabasesPath(), 'learning_history.db');
    
    return await openDatabase(
      path, 
      version: 2, // TĂNG LÊN VERSION 2
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            object_name TEXT,
            image_data TEXT,
            box_data TEXT,  -- CỘT MỚI ĐỂ LƯU TỌA ĐỘ [x1, y1, x2, y2]
            timestamp TEXT
          )
        ''');
      },
      // HÀM NÀY GIÚP NÂNG CẤP BẢNG MÀ KHÔNG LÀM MẤT DỮ LIỆU CŨ
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE history ADD COLUMN box_data TEXT;");
        }
      },
    );
  }

  // Cập nhật hàm save: Nhận thêm List tọa độ box
  Future<void> saveToHistory(String name, String base64Image, List<dynamic> box) async {
    final db = await database;
    await db.insert('history', {
      'object_name': name,
      'image_data': base64Image,
      'box_data': jsonEncode(box), 
      'timestamp': DateTime.now().toIso8601String(),
    });
    print(" Đã lưu $name kèm tọa độ vào máy!");
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }
}