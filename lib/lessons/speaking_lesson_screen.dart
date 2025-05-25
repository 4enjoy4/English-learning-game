import 'package:flutter/material.dart';

// Speaking Lesson
class SpeakingLessonScreen extends StatelessWidget {
  const SpeakingLessonScreen({super.key});

  final List<Map<String, String>> prompts = const [
    {'prompt': 'Introduce yourself in 2 sentences.'},
    {'prompt': 'Describe your favorite food.'},
    {'prompt': 'Talk about what you did yesterday.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speaking Skills')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                prompts[index]['prompt']!,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.mic),
            ),
          );
        },
      ),
    );
  }
}