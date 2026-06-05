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
      version: 3,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            object_name TEXT,
            image_data TEXT,
            box_data TEXT,  -- CỘT ĐỂ LƯU TỌA ĐỘ [x1, y1, x2, y2]
            confidence REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE history ADD COLUMN box_data TEXT;");
        }
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE history ADD COLUMN confidence REAL;");
        }
      },
    );
  }

  Future<void> saveToHistory(
    String name,
    String base64Image,
    List<dynamic> box,
    double confidence,
  ) async {
    final db = await database;
    await db.insert('history', {
      'object_name': name,
      'image_data': base64Image,
      'box_data': jsonEncode(box),
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print(" Đã lưu $name kèm tọa độ vào máy!");
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }
}
