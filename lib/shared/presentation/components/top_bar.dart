import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback onNavigationClick;

  const TopBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    required this.onNavigationClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4ECEC),
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF4A1B2A),
              onPressed: onNavigationClick,
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              color: const Color(0xFF4A1B2A),
              onPressed: onNavigationClick,
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF4A1B2A),
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
