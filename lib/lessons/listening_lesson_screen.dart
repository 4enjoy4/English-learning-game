import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Listening Lesson
class ListeningLessonScreen extends StatefulWidget {
  const ListeningLessonScreen({super.key});

  @override
  State<ListeningLessonScreen> createState() => _ListeningLessonScreenState();
}

class _ListeningLessonScreenState extends State<ListeningLessonScreen> {
  List<String> words = ['apple', 'run', 'weather'];
  int currentIndex = 0;
  Map<String, dynamic>? wordData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWordData(words[currentIndex]);
  }

  Future<void> fetchWordData(String word) async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        wordData = data[0];
        isLoading = false;
      });
    }
  }

  void nextWord() {
    setState(() {
      currentIndex = (currentIndex + 1) % words.length;
    });
    fetchWordData(words[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final phonetic = wordData?['phonetics']?[0]?['text'] ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Listening Practice')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wordData == null
          ? const Center(child: Text('No data loaded.'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              wordData!['word'],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            if (phonetic.isNotEmpty)
              Text(
                phonetic,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            const Text('Definitions:'),
            ...wordData!['meanings'].map<Widget>((m) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- ${m['partOfSpeech']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate(m['definitions'].length, (i) {
                    return Text("• ${m['definitions'][i]['definition']}");
                  }),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: nextWord,
              child: const Text('Next Word'),
            )
          ],
        ),
      ),
    );
  }
}