import 'package:flutter/material.dart';
import '../../../models/lesson.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(lesson.imagePath, height: 200, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              lesson.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              lesson.description,
              style: TextStyle(fontSize: 16),
            ),
            // TODO: Add interactive content here
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to quiz or start activity
              },
              child: Text('Start Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}
