import 'package:flutter/material.dart';

class PhrasesLessonScreen extends StatelessWidget {
  const PhrasesLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Common Phrases')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          LessonCard(title: 'Greetings', content: 'Hello, Good morning, How are you?, Nice to meet you'),
          LessonCard(title: 'Polite Expressions', content: 'Please, Thank you, Excuse me, Sorry'),
          LessonCard(title: 'Basic Questions', content: 'What is your name?, Where are you from?'),
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