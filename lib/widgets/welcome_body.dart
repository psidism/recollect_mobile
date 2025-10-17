import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconBox(),
          const SizedBox(height: 16),
          const Text(
            'Welcome to ReCollect',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Open the drawer to view your documents',
            style: TextStyle(fontFamily: 'Times New Roman', fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            "Your thoughts, beautifully organized",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
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
    );
  }
}
