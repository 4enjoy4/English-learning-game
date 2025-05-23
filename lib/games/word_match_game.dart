import 'package:flutter/material.dart';

class WordMatchGame extends StatefulWidget {
  @override
  _WordMatchGameState createState() => _WordMatchGameState();
}

class _WordMatchGameState extends State<WordMatchGame> {
  final List<Map<String, String>> pairs = [
    {'word': 'Happy', 'definition': 'Feeling joy'},
    {'word': 'Run', 'definition': 'Move fast by foot'},
    {'word': 'Apple', 'definition': 'A red or green fruit'},
  ];

  final Map<String, String> selectedMatches = {};
  String? selectedWord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Word Match Game')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Match the word to its correct definition.', style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: pairs.map((pair) => _buildWordTile(pair['word']!)).toList(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: pairs.map((pair) => _buildDefinitionTile(pair['definition']!)).toList(),
                  ),
                ),
              ],
            ),
          ),
          if (selectedMatches.length == pairs.length)
            ElevatedButton(
              onPressed: _checkAnswers,
              child: Text('Check Answers'),
            ),
        ],
      ),
    );
  }

  Widget _buildWordTile(String word) {
    return ListTile(
      title: Text(word),
      tileColor: selectedWord == word ? Colors.blue[100] : null,
      onTap: () {
        setState(() {
          selectedWord = word;
        });
      },
    );
  }

  Widget _buildDefinitionTile(String definition) {
    return ListTile(
      title: Text(definition),
      tileColor: selectedMatches[selectedWord] == definition ? Colors.green[100] : null,
      onTap: () {
        if (selectedWord != null) {
          setState(() {
            selectedMatches[selectedWord!] = definition;
            selectedWord = null;
          });
        }
      },
    );
  }

  void _checkAnswers() {
    int score = 0;
    for (var pair in pairs) {
      if (selectedMatches[pair['word']] == pair['definition']) {
        score++;
      }
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Results'),
        content: Text('You matched $score out of ${pairs.length} correctly!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
