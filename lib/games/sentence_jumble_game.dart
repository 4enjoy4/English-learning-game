import 'package:flutter/material.dart';
import 'dart:math';

class SentenceJumbleGame extends StatefulWidget {
  @override
  _SentenceJumbleGameState createState() => _SentenceJumbleGameState();
}

class _SentenceJumbleGameState extends State<SentenceJumbleGame> {
  final List<Map<String, dynamic>> _sentences = [
    {
      'correct': 'The cat sat on the mat',
      'words': ['The', 'cat', 'sat', 'on', 'the', 'mat']
    },
    {
      'correct': 'I love learning English',
      'words': ['I', 'love', 'learning', 'English']
    },
    {
      'correct': 'Flutter makes development fun',
      'words': ['Flutter', 'makes', 'development', 'fun']
    }
  ];

  int _currentIndex = 0;
  List<String> _shuffledWords = [];
  List<String> _userSelection = [];

  @override
  void initState() {
    super.initState();
    _loadSentence();
  }

  void _loadSentence() {
    _userSelection.clear();
    _shuffledWords = List<String>.from(_sentences[_currentIndex]['words']);
    _shuffledWords.shuffle(Random());
  }

  void _checkAnswer() {
    String userSentence = _userSelection.join(' ');
    String correctSentence = _sentences[_currentIndex]['correct'];

    bool isCorrect = userSentence == correctSentence;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
        content: Text('Your sentence: "$userSentence"'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_currentIndex < _sentences.length - 1) {
                  _currentIndex++;
                } else {
                  _currentIndex = 0;
                }
                _loadSentence();
              });
            },
            child: Text('Next'),
          )
        ],
      ),
    );
  }

  Widget _buildWordButton(String word) {
    return ElevatedButton(
      onPressed: _userSelection.contains(word)
          ? null
          : () {
        setState(() {
          _userSelection.add(word);
        });
      },
      child: Text(word),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sentence Jumble')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Form a correct sentence:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _shuffledWords.map((w) => _buildWordButton(w)).toList(),
            ),
            SizedBox(height: 20),
            Text('Your Sentence:', style: TextStyle(fontSize: 16)),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Text(_userSelection.join(' '), style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _userSelection.length == _shuffledWords.length ? _checkAnswer : null,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
