import 'dart:convert';
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
            object_name_vn TEXT,
            image_data TEXT,
            box_data TEXT,
            confidence REAL,
            timestamp TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute("ALTER TABLE history ADD COLUMN box_data TEXT;");
          db.execute("ALTER TABLE history ADD COLUMN confidence REAL;");
        }
        if (oldVersion < 3) {
          db.execute("ALTER TABLE history ADD COLUMN object_name_vn TEXT;");
        }
      },
    );
  }

  // Sắp xếp lại tham số cho khoa học
  Future<void> saveToHistory({
    required String name,
    required String vnName,
    required String base64Image,
    required List<dynamic> box,
    required double confidence,
  }) async {
    final db = await database;
    await db.insert('history', {
      'object_name': name,
      'object_name_vn': vnName,
      'image_data': base64Image,
      'box_data': jsonEncode(box),
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print(" Đã lưu $name ($vnName) vào máy!");
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }
}