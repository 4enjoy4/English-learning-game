import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart'; // adjust this import as needed

class WordMatchGame extends StatefulWidget {
  @override
  _WordMatchGameState createState() => _WordMatchGameState();
}

class _WordMatchGameState extends State<WordMatchGame> {
  final List<Map<String, String>> allPairs = [
    {'word': 'Happy', 'definition': 'Feeling joy'},
    {'word': 'Run', 'definition': 'Move fast by foot'},
    {'word': 'Apple', 'definition': 'A red or green fruit'},
    {'word': 'Book', 'definition': 'A set of written pages'},
    {'word': 'Cat', 'definition': 'A small domesticated animal'},
    {'word': 'Sun', 'definition': 'The star at the center of our solar system'},
  ];

  late List<Map<String, String>> pairs; // current pairs (6)
  late List<String> words;
  late List<String> definitions;

  Map<String, String> selectedMatches = {};
  String? selectedWord;
  bool checked = false;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _restartGame();
  }

  void _restartGame() {
    pairs = List<Map<String, String>>.from(allPairs);
    pairs.shuffle(random);

    words = pairs.map((pair) => pair['word']!).toList()..shuffle(random);
    definitions = pairs.map((pair) => pair['definition']!).toList()..shuffle(random);

    selectedMatches.clear();
    selectedWord = null;
    checked = false;

    setState(() {});
  }

  void _checkAnswers(UserDataService userData) {
    int correctCount = 0;
    for (var pair in pairs) {
      if (selectedMatches[pair['word']] == pair['definition']) {
        correctCount++;
      }
    }

    // Reduced XP: 5 XP per correct match (adjust as you want)
    int earnedXP = correctCount * 5;

    // Add XP to user profile service
    userData.addXP(earnedXP);

    setState(() {
      checked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You earned $earnedXP XP!')),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Results'),
        content: Text('You matched $correctCount out of ${pairs.length} correctly!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  Widget _buildWordTile(String word) {
    bool isSelected = selectedWord == word;
    bool isMatched = selectedMatches.containsKey(word);
    Color? tileColor;
    if (checked && isMatched) {
      final correctDef = pairs.firstWhere((pair) => pair['word'] == word)['definition'];
      final selectedDef = selectedMatches[word];
      tileColor = correctDef == selectedDef ? Colors.green.shade200 : Colors.red.shade200;
    } else {
      tileColor = isSelected
          ? Colors.blue.shade100
          : isMatched
          ? Colors.green.shade50
          : null;
    }

    return Card(
      color: tileColor,
      child: ListTile(
        title: Text(
          word,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: isMatched ? Icon(Icons.check_circle, color: Colors.green) : null,
        onTap: checked
            ? null
            : () {
          setState(() {
            if (selectedWord == word) {
              selectedWord = null;
            } else {
              selectedWord = word;
            }
          });
        },
      ),
    );
  }

  Widget _buildDefinitionTile(String definition) {
    String? matchedWord;
    selectedMatches.forEach((w, d) {
      if (d == definition) matchedWord = w;
    });

    bool isMatched = matchedWord != null;

    Color? tileColor;
    if (checked && isMatched) {
      final correctDef = pairs.firstWhere((pair) => pair['word'] == matchedWord)['definition'];
      tileColor = correctDef == definition ? Colors.green.shade200 : Colors.red.shade200;
    } else if (isMatched) {
      tileColor = Colors.green.shade50;
    } else if (selectedWord != null && !checked) {
      tileColor = Colors.blue.shade100;
    }

    return Card(
      color: tileColor,
      child: ListTile(
        title: Text(
          definition,
          style: TextStyle(fontSize: 14),
        ),
        trailing: isMatched ? Icon(Icons.link) : null,
        onTap: checked
            ? null
            : () {
          if (selectedWord == null) return;
          setState(() {
            // Remove any previous match to this definition
            String? oldWord;
            selectedMatches.forEach((w, d) {
              if (d == definition) oldWord = w;
            });
            if (oldWord != null) {
              selectedMatches.remove(oldWord);
            }
            selectedMatches[selectedWord!] = definition;
            selectedWord = null;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Match Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Match the word to its correct definition.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      children: words.map(_buildWordTile).toList(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ListView(
                      children: definitions.map(_buildDefinitionTile).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            if (!checked && selectedMatches.length == pairs.length)
              ElevatedButton(
                onPressed: () => _checkAnswers(userData),
                child: Text('Check Answers'),
              ),
            if (checked)
              ElevatedButton(
                onPressed: _restartGame,
                child: Text('Restart Game'),
              ),
          ],
        ),
      ),
    );
  }
}
