import 'package:flutter/material.dart';

class VocabularyLessonScreen extends StatelessWidget {
  const VocabularyLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Lessons')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          LessonCard(title: 'Fruits', content: 'apple, banana, orange, grape, mango'),
          LessonCard(title: 'Animals', content: 'dog, cat, lion, elephant, zebra'),
          LessonCard(title: 'Colors', content: 'red, blue, green, yellow, black'),
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