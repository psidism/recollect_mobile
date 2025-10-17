// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../models/document.dart';

class CustomDrawer extends StatelessWidget {
  final List<Document> documents;
  final bool isLoading;
  final Function(Document) onDocumentTap;
  final Function(int) onDeleteDocument;

  const CustomDrawer({
    super.key,
    required this.documents,
    required this.isLoading,
    required this.onDocumentTap,
    required this.onDeleteDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          _buildDocumentsHeader(),
          const Divider(height: 1),
          Expanded(child: _buildDocumentList()),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return SizedBox(
      height: 140,
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 249, 248, 245),
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 230,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  GestureDetector(
                    child: const Text(
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
    );
  }

  Widget _buildDocumentsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Documents (${documents.length})',
            style: const TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (documents.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No documents yet.\nTap + to create one!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Times New Roman',
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _buildDocumentCard(doc);
      },
    );
  }

  Widget _buildDocumentCard(Document doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color.fromARGB(255, 255, 255, 255),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 238, 234),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.description,
            size: 20,
            color: Color.fromARGB(255, 139, 157, 140),
          ),
        ),
        title: Text(
          doc.title,
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          doc.content.isEmpty
              ? 'Empty document'
              : doc.content.length > 30
              ? '${doc.content.substring(0, 30)}...'
              : doc.content,
          style: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 12,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
          onPressed: () {
            if (doc.id != null) {
              onDeleteDocument(doc.id!);
            }
          },
        ),
        onTap: () => onDocumentTap(doc),
      ),
    );
  }
}
