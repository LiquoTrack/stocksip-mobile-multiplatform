import 'package:flutter/material.dart';

class NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const NavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}