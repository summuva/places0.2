import 'package:flutter/material.dart';

class PublicationsScreen extends StatelessWidget {
  const PublicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Publicaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Eventos y publicaciones de la comunidad',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}