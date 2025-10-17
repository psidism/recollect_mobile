import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddPressed;

  const CustomAppBar({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1.0,
      backgroundColor: const Color.fromARGB(255, 250, 249, 247),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 80),
          const Center(child: Text('ReCollect')),
          const SizedBox(width: 100),
          GestureDetector(child: const Icon(Icons.add), onTap: onAddPressed),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
