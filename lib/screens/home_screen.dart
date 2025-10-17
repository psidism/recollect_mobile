// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/document.dart';
import '../services/database_helper.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/welcome_body.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _onDocumentTap(Document doc) async {
    Navigator.pop(context); // Close drawer

    // Navigate to editor
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditorScreen(document: doc)),
    );

    // Reload documents when coming back
    await _loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 248, 245),
      drawer: CustomDrawer(
        documents: _documents,
        isLoading: _isLoading,
        onDocumentTap: _onDocumentTap,
        onDeleteDocument: _deleteDocument,
      ),
      appBar: CustomAppBar(onAddPressed: _createNewDocument),
      body: const WelcomeBody(),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
