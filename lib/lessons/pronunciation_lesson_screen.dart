import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Pronunciation Lesson
class PronunciationLessonScreen extends StatefulWidget {
  const PronunciationLessonScreen({super.key});

  @override
  State<PronunciationLessonScreen> createState() => _PronunciationLessonScreenState();
}

class _PronunciationLessonScreenState extends State<PronunciationLessonScreen> {
  final List<String> testWords = ['think', 'zebra', 'knife'];
  int current = 0;
  Map<String, dynamic>? wordData;

  @override
  void initState() {
    super.initState();
    fetchWordData(testWords[current]);
  }

  Future<void> fetchWordData(String word) async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => wordData = data[0]);
    }
  }

  void nextWord() {
    setState(() {
      current = (current + 1) % testWords.length;
    });
    fetchWordData(testWords[current]);
  }

  @override
  Widget build(BuildContext context) {
    final phonetic = wordData?['phonetics']?[0]?['text'] ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Pronunciation Practice')),
      body: wordData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              wordData!['word'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (phonetic.isNotEmpty)
              Text(phonetic, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text('Say this word out loud!'),
            const Spacer(),
            ElevatedButton(
              onPressed: nextWord,
              child: const Text('Next Word'),
            ),
          ],
        ),
      ),
    );
  }
}