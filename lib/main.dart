// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'models/document.dart';
import 'services/database_helper.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Document> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    final documents = await _dbHelper.getAllDocuments();
    setState(() {
      _documents = documents;
      _isLoading = false;
    });
  }

  Future<void> _createNewDocument() async {
    final now = DateTime.now();
    final newDoc = Document(
      title: 'Untitled Document',
      content: '',
      createdAt: now,
      updatedAt: now,
    );

    final createdDoc = await _dbHelper.createDocument(newDoc);
    await _loadDocuments();
    print('Created document with ID: ${createdDoc.id}');
  }

  Future<void> _deleteDocument(int id) async {
    await _dbHelper.deleteDocument(id);
    await _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 248, 245),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 140,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 249, 248, 245),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 230,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 238, 234),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 10),
                          GestureDetector(
                            child: Text(
                              'Search file...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            onTap: () {
                              print("Search Bar clicked");
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('All Documents (${_documents.length})'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 80),
            Center(child: Text('ReCollect')),
            SizedBox(width: 100),
            GestureDetector(child: Icon(Icons.add), onTap: _createNewDocument),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 238, 234),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 248, 246, 243),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.edit_document,
                          size: 50,
                          color: Color.fromARGB(255, 139, 157, 140),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Welcome to ReCollect',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Times New Roman',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tap the + button to create your first document',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Your thoughts, beautifully organized",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _documents.length,
              itemBuilder: (context, index) {
                final doc = _documents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 238, 234),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description,
                        color: Color.fromARGB(255, 139, 157, 140),
                      ),
                    ),
                    title: Text(
                      doc.title,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      doc.content.isEmpty
                          ? 'Empty document'
                          : doc.content.length > 50
                          ? '${doc.content.substring(0, 50)}...'
                          : doc.content,
                      style: TextStyle(
                        fontFamily: 'Times New Roman',
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        if (doc.id != null) {
                          _deleteDocument(doc.id!);
                        }
                      },
                    ),
                    onTap: () {
                      print('Tapped on document: ${doc.title}');
                      // TODO: Navigate to editor screen
                    },
                  ),
                );
              },
            ),
    );
  }
}
