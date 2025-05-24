import 'package:flutter/material.dart';

class GrammarLessonScreen extends StatelessWidget {
  const GrammarLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Rules')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          LessonCard(title: 'Present Simple Tense', content: 'I go, You eat, He sleeps'),
          LessonCard(title: 'Past Simple Tense', content: 'I went, You ate, He slept'),
          LessonCard(title: 'Future Simple Tense', content: 'I will go, You will eat, He will sleep'),
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