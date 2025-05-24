import 'package:flutter/material.dart';

class ListeningLessonScreen extends StatelessWidget {
  const ListeningLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listening Practice')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          LessonCard(title: 'Identify Words', content: 'Listen and pick the correct word'),
          LessonCard(title: 'Short Dialogues', content: 'Listen to simple conversations'),
          LessonCard(title: 'Story Practice', content: 'Listen to short stories and answer questions'),
        ],
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final String title;
  final String content;

  const LessonCard({required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}