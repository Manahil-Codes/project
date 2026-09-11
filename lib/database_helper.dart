import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('skillsync.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE roadmaps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<int> insertRoadmap(
    String title,
    String description,
  ) async {
    final db = await database;

    return await db.insert(
      'roadmaps',
      {
        'title': title,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getRoadmaps() async {
    final db = await database;

    return await db.query(
      'roadmaps',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteRoadmap(int id) async {
    final db = await database;

    return await db.delete(
      'roadmaps',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}