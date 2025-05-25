import 'package:flutter/material.dart';

// Phrases Lesson
class PhrasesLessonScreen extends StatelessWidget {
  const PhrasesLessonScreen({super.key});

  final List<Map<String, String>> phrases = const [
  {'phrase': 'How are you?', 'meaning': 'Used to ask about someones well being'},
  {'phrase': 'See you later!', 'meaning': 'Used when leaving someone, implying you will meet again'},
  {'phrase': 'I am just looking', 'meaning': 'Used in stores to say you are browsing'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Common Phrases')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final phrase = phrases[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(phrase['phrase']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(phrase['meaning']!),
            ),
          );
        },
      ),
    );
  }
}