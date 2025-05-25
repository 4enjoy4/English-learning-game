import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PhrasesLessonScreen extends StatefulWidget {
  const PhrasesLessonScreen({super.key});

  @override
  State<PhrasesLessonScreen> createState() => _PhrasesLessonScreenState();
}

class _PhrasesLessonScreenState extends State<PhrasesLessonScreen> {
  final List<String> categories = [
    "Everyday",
    "Business",
    "Academic",
    "Travel",
    "Shopping",
    "Emergency",
    "Dining",
    "Technology",
    "Health"
  ];

  Map<String, List<dynamic>> phrasesByCategory = {};
  String? selectedCategory;
  bool isLoading = false;

  List<Map<String, String>> allPhrasesInCategory = [];
  List<Map<String, String>> displayedPhrases = [];

  static const int batchSize = 10;

  @override
  void initState() {
    super.initState();
    loadAllPhrases();
  }

  Future<void> loadAllPhrases() async {
    setState(() => isLoading = true);
    try {
      final jsonString = await rootBundle.loadString('assets/json_files/phrases.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, dynamic>? phrasesMap = jsonData['phrases'];
      if (phrasesMap == null) {
        throw Exception('Missing "phrases" key in JSON');
      }

      phrasesByCategory = {};
      phrasesMap.forEach((key, value) {
        if (value is List) {
          phrasesByCategory[key] = value;
        }
      });

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error loading phrases JSON: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading phrases JSON: $e')),
      );
    }
  }

  void fetchPhrases(String category) {
    setState(() {
      isLoading = true;
      selectedCategory = category;
      displayedPhrases = [];
      allPhrasesInCategory = [];
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      final rawList = phrasesByCategory[category] ?? [];

      final List<Map<String, String>> phrases = [];
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          phrases.add({
            'phrase': item['phrase']?.toString() ?? '',
            'meaning': item['meaning']?.toString() ?? '',
            'example': item['example']?.toString() ?? '',
          });
        }
      }

      allPhrasesInCategory = List.from(phrases);
      _loadNextBatch();

      setState(() {
        isLoading = false;
      });
    });
  }

  void _loadNextBatch() {
    if (allPhrasesInCategory.isEmpty) return;

    // Shuffle all phrases
    allPhrasesInCategory.shuffle(Random());

    // Take next batchSize phrases
    final nextBatch = allPhrasesInCategory.take(batchSize).toList();

    setState(() {
      displayedPhrases = nextBatch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Common Phrases")),
      body: selectedCategory == null
          ? GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              fetchPhrases(category);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      )
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedCategory!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    selectedCategory = null;
                    displayedPhrases = [];
                    allPhrasesInCategory = [];
                  }),
                  child: const Text("Back"),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayedPhrases.length,
                itemBuilder: (context, index) {
                  final phrase = displayedPhrases[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(phrase['phrase']!,
                          style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phrase['meaning']!),
                          const SizedBox(height: 6),
                          Text("Example: ${phrase['example']!}",
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (!isLoading && displayedPhrases.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                onPressed: () {
                  _loadNextBatch();
                },
                icon: const Icon(Icons.shuffle),
                label: const Text('Shuffle'),
              ),
            ),
        ],
      ),
    );
  }
}
