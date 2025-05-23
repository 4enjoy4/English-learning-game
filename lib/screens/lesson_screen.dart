import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  final List<_Lesson> lessons = [
    _Lesson('Basic Vocabulary', 'assets/images/vocab.png'),
    _Lesson('Common Phrases', 'assets/images/phrases.png'),
    _Lesson('Grammar Rules', 'assets/images/grammar.png'),
    _Lesson('Pronunciation', 'assets/images/pronunciation.png'),
    _Lesson('Listening Practice', 'assets/images/listening.png'),
    _Lesson('Speaking Skills', 'assets/images/speaking.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lessons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return GestureDetector(
          onTap: () {
            // TODO: Navigate to specific lesson content
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(lesson.imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                )
              ],
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(8),
            child: Text(
              lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

class _Lesson {
  final String title;
  final String imagePath;

  _Lesson(this.title, this.imagePath);
}
