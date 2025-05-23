import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Level: 0', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Progress', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            LinearProgressIndicator(value: 0.25),
            SizedBox(height: 20),
            Text('Achievements: None yet.')
          ],
        ),
      ),
    );
  }
}