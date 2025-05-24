import 'package:flutter/material.dart';

class PronunciationLessonScreen extends StatelessWidget {
  const PronunciationLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pronunciation')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          LessonCard(title: 'Consonant Sounds', content: 'b, d, g, k, p, t'),
          LessonCard(title: 'Vowel Sounds', content: 'a, e, i, o, u'),
          LessonCard(title: 'Word Stress', content: 'REcord vs. reCORD, PREsent vs. preSENT'),
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