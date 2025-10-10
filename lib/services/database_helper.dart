import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recollect.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE documents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  // Create a new document
  Future<Document> createDocument(Document document) async {
    final db = await database;
    final id = await db.insert('documents', document.toMap());
    return document.copyWith(id: id);
  }

  // Read all documents
  Future<List<Document>> getAllDocuments() async {
    final db = await database;
    final result = await db.query('documents', orderBy: 'updatedAt DESC');
    return result.map((map) => Document.fromMap(map)).toList();
  }

  // Read a single document
  Future<Document?> getDocument(int id) async {
    final db = await database;
    final maps = await db.query('documents', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Document.fromMap(maps.first);
    }
    return null;
  }

  // Update a document
  Future<int> updateDocument(Document document) async {
    final db = await database;
    return db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }

  // Delete a document
  Future<int> deleteDocument(int id) async {
    final db = await database;
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  // Search documents by title or content
  Future<List<Document>> searchDocuments(String query) async {
    final db = await database;
    final result = await db.query(
      'documents',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'updatedAt DESC',
    );
    return result.map((map) => Document.fromMap(map)).toList();
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

//MAKE COMMENTS
