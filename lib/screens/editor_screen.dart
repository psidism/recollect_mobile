import 'package:flutter/material.dart';
import '../models/document.dart';
import '../services/database_helper.dart';

class EditorScreen extends StatefulWidget {
  final Document document;
  const EditorScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document.title);
    _contentController = TextEditingController(text: widget.document.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveDocument() async {
    final updatedDocument = Document(
      id: widget.document.id,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: widget.document.createdAt,
      updatedAt: DateTime.now(),
    );

    await DatabaseHelper.instance.updateDocument(updatedDocument);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Document saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 248, 245),
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: const Color.fromARGB(255, 250, 249, 247),
        title: const Text('Edit Document'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveDocument),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Times New Roman',
              ),
              decoration: const InputDecoration(
                hintText: 'Document Title',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Times New Roman',
                ),
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
