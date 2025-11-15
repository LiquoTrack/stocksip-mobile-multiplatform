import 'package:flutter/material.dart';
import 'package:stocksip/shared/presentation/widgets/drawer_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),

      drawer: const DrawerNavigation(),

      body: const Center(
        child: Text(
          'Welcome to the home page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}