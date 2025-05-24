import 'package:flutter/material.dart';

import '../lessons/grammar_lesson_screen.dart';
import '../lessons/listening_lesson_screen.dart';
import '../lessons/phrases_lesson_screen.dart';
import '../lessons/pronunciation_lesson_screen.dart';
import '../lessons/speaking_lesson_screen.dart';
import '../lessons/vocabulary_lesson_screen.dart';


class Lesson {
  final String title;
  final IconData icon;

  Lesson({required this.title, required this.icon});
}

class LessonsScreen extends StatelessWidget {
  LessonsScreen({super.key});

  final List<Lesson> lessons = [
    Lesson(title: 'Basic Vocabulary', icon: Icons.language),
    Lesson(title: 'Common Phrases', icon: Icons.chat),
    Lesson(title: 'Grammar Rules', icon: Icons.rule),
    Lesson(title: 'Pronunciation', icon: Icons.volume_up),
    Lesson(title: 'Listening Practice', icon: Icons.headphones),
    Lesson(title: 'Speaking Skills', icon: Icons.record_voice_over),
  ];

  void _navigateToLesson(BuildContext context, String title) {
    Widget screen;

    switch (title) {
      case 'Basic Vocabulary':
        screen = const VocabularyLessonScreen();
        break;
      case 'Common Phrases':
        screen = const PhrasesLessonScreen();
        break;
      case 'Grammar Rules':
        screen = const GrammarLessonScreen();
        break;
      case 'Pronunciation':
        screen = const PronunciationLessonScreen();
        break;
      case 'Listening Practice':
        screen = const ListeningLessonScreen();
        break;
      case 'Speaking Skills':
        screen = const SpeakingLessonScreen();
        break;
      default:
        screen = const VocabularyLessonScreen(); // fallback
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('English Lessons')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: lessons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return GestureDetector(
            onTap: () => _navigateToLesson(context, lesson.title),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(lesson.icon, size: 48, color: Colors.blueAccent),
                  const SizedBox(height: 12),
                  Text(
                    lesson.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
