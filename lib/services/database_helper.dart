import 'package:sqflite/sqflite.dart'; // import the filing cabinet library
import 'package:path/path.dart'; // helps create file paths/addresses
import '../models/document.dart'; // import our Document template

class DatabaseHelper {
  // this is the person who manages the filing cabinet

  // SINGLETON PATTERN - only ONE database helper exists in the whole app
  // like having ONE key to the filing cabinet, not 50 copies
  static final DatabaseHelper instance = DatabaseHelper._init();

  // the actual database object - nullable because it doesn't exist yet when app starts
  static Database? _database;

  // private constructor (the underscore _ makes it private)
  // this prevents anyone from creating new DatabaseHelpers with DatabaseHelper()
  DatabaseHelper._init();

  // getter that returns the database
  // if database already exists, return it
  // if not, create it first, then return it
  Future<Database> get database async {
    if (_database != null) return _database!; // already exists, return it
    _database = await _initDB('recollect.db'); // doesn't exist, create it
    return _database!; // return the newly created database
  }

  // this function creates/opens the database file
  Future<Database> _initDB(String filePath) async {
    // ask the phone "where should I store databases?"
    final dbPath = await getDatabasesPath();

    // combine the database folder path + our filename
    // like combining "Documents/databases" + "recollect.db"
    // result: "Documents/databases/recollect.db"
    final path = join(dbPath, filePath);

    // open the database at that path
    // if it doesn't exist, CREATE it
    // if it exists, just open it
    return await openDatabase(
      path, // where the database file lives
      version: 1, // database version (useful for upgrades later)
      onCreate:
          _createDB, // if database doesn't exist, run this function to build it
    );
  }

  // this function CREATES the structure of the database
  // only runs the FIRST time, when database doesn't exist yet
  Future<void> _createDB(Database db, int version) async {
    // execute SQL command to create a table (like creating a spreadsheet)
    await db.execute('''
      CREATE TABLE documents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
    // INTEGER PRIMARY KEY AUTOINCREMENT = automatically gives unique ID numbers (1, 2, 3...)
    // TEXT NOT NULL = this field must have text, can't be empty
  }

  // ========== CRUD OPERATIONS ==========
  // CRUD = Create, Read, Update, Delete

  // CREATE - add a new document to the database
  Future<Document> createDocument(Document document) async {
    final db = await database; // open the filing cabinet

    // insert the document into the 'documents' table
    // toMap() converts our Document object into a format the database understands
    // returns the new document's ID number
    final id = await db.insert('documents', document.toMap());

    // return the same document but now WITH the ID number
    // copyWith adds the ID without changing anything else
    return document.copyWith(id: id);
  }

  // READ ALL - get every single document from the database
  Future<List<Document>> getAllDocuments() async {
    final db = await database; // open the filing cabinet

    // query = ask the database for data
    // 'documents' = the table name
    // orderBy = sort the results
    // 'updatedAt DESC' = newest documents first (DESC = descending)
    final result = await db.query('documents', orderBy: 'updatedAt DESC');

    // result is a List of Maps
    // we need to convert each Map into a Document object
    // .map() = go through each item in the list
    // Document.fromMap(map) = convert each Map to Document
    // .toList() = convert back into a List
    return result.map((map) => Document.fromMap(map)).toList();
  }

  // READ ONE - get a specific document by its ID
  Future<Document?> getDocument(int id) async {
    // returns Document? (nullable) because the ID might not exist
    final db = await database; // open the filing cabinet

    // query for documents WHERE the id matches what we're looking for
    // where: 'id = ?' = find rows where id equals something
    // whereArgs: [id] = replace the ? with the actual id value
    // this is safer than putting the id directly in the string (prevents SQL injection)
    final maps = await db.query('documents', where: 'id = ?', whereArgs: [id]);

    // if we found something, return the first result as a Document
    if (maps.isNotEmpty) {
      return Document.fromMap(maps.first);
    }
    // if we didn't find anything, return null
    return null;
  }

  // UPDATE - change an existing document
  Future<int> updateDocument(Document document) async {
    // returns int = number of rows affected (should be 1)
    final db = await database; // open the filing cabinet

    // update the 'documents' table
    // set the new values (from document.toMap())
    // WHERE the id matches
    // returns how many rows were updated
    return db.update(
      'documents',
      document.toMap(), // new data to save
      where: 'id = ?', // find the document with this ID
      whereArgs: [document.id], // the actual ID value
    );
  }

  // DELETE - remove a document permanently
  Future<int> deleteDocument(int id) async {
    // returns int = number of rows deleted (should be 1)
    final db = await database; // open the filing cabinet

    // delete from 'documents' table
    // WHERE the id matches what we want to delete
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  // SEARCH - find documents that match a search term
  Future<List<Document>> searchDocuments(String query) async {
    final db = await database; // open the filing cabinet

    // LIKE = SQL's way of searching for text that contains something
    // '%$query%' = find text that has the query anywhere in it
    // % = wildcard (matches any characters)
    // if query = "hello", this finds "hello", "say hello", "hello world", etc.
    final result = await db.query(
      'documents',
      where: 'title LIKE ? OR content LIKE ?', // search in title OR content
      whereArgs: [
        '%$query%',
        '%$query%',
      ], // the actual search term (wrapped with %)
      orderBy: 'updatedAt DESC', // newest first
    );

    // convert all results from Maps to Document objects
    return result.map((map) => Document.fromMap(map)).toList();
  }

  // CLOSE - properly close the database when done
  // important to prevent memory leaks
  Future<void> close() async {
    final db = await database; // get the database
    await db.close(); // close it
  }
}
