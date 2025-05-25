import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class PronunciationLessonScreen extends StatefulWidget {
  const PronunciationLessonScreen({Key? key}) : super(key: key);

  @override
  State<PronunciationLessonScreen> createState() => _PronunciationLessonScreenState();
}

class _PronunciationLessonScreenState extends State<PronunciationLessonScreen> {
  final List<String> categories = [
    "Animals",
    "Fruits",
    "Actions",
    "Emotions",
    "Colors",
    "Body Parts",
    "Transport",
    "Occupations",
    "Weather",
    "Household Items",
  ];

  String? selectedCategory;
  List<String> words = [];
  List<Map<String, dynamic>> wordDataList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadWordsFromJson(String category) async {
    setState(() {
      isLoading = true;
      wordDataList.clear();
      words.clear();
    });

    final String response =
    await rootBundle.loadString('assets/json_files/pronunciation_words.json');
    final data = json.decode(response);
    final List<String> categoryWords = List<String>.from(data[category] ?? []);

    words = categoryWords;
    await fetchWordData();

    setState(() {
      selectedCategory = category;
      isLoading = false;
    });
  }

  Future<void> fetchWordData() async {
    for (String word in words) {
      final res = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
      if (res.statusCode == 200) {
        final jsonBody = json.decode(res.body);
        if (jsonBody is List && jsonBody.isNotEmpty) {
          wordDataList.add(jsonBody[0]);
        }
      }
    }
  }

  Widget buildCategoryView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: categories
          .map((category) => Card(
        child: ListTile(
          title: Text(category),
          onTap: () => loadWordsFromJson(category),
        ),
      ))
          .toList(),
    );
  }

  Widget buildWordView() {
    return ListView.builder(
      itemCount: wordDataList.length,
      itemBuilder: (context, index) {
        final wordData = wordDataList[index];
        final word = wordData['word'] ?? '';
        final phonetics = wordData['phonetics'] ?? [];
        final meanings = wordData['meanings'] ?? [];

        final audioUrl = phonetics.firstWhere(
              (p) => p['audio'] != null && p['audio'].toString().isNotEmpty,
          orElse: () => {'audio': ''},
        )['audio'] ??
            '';

        final phonetic = phonetics.firstWhere(
              (p) => p['text'] != null && p['text'].toString().isNotEmpty,
          orElse: () => {'text': ''},
        )['text'] ??
            '';

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(word, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (phonetic.isNotEmpty) Text(phonetic),
                if (meanings.isNotEmpty)
                  Text(
                    meanings[0]['partOfSpeech'] ?? '',
                    style: const TextStyle(color: Colors.blue),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: audioUrl.isNotEmpty ? () => playAudio(audioUrl) : null,
            ),
          ),
        );
      },
    );
  }

  void playAudio(String url) async {
    final player = AudioPlayer();
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedCategory ?? 'Pronunciation Lessons'),
        leading: selectedCategory != null
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedCategory = null;
              wordDataList.clear();
            });
          },
        )
            : null,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : selectedCategory == null
          ? buildCategoryView()
          : buildWordView(),
    );
  }
}
