import 'package:flutter/material.dart';

class ErrorSpottingGame extends StatefulWidget {
  @override
  _ErrorSpottingGameState createState() => _ErrorSpottingGameState();
}

class _ErrorSpottingGameState extends State<ErrorSpottingGame> {
  final List<Map<String, dynamic>> _questions = [
    {
      'sentence': 'He go to school every day.',
      'error': 'go',
      'correct': 'goes'
    },
    {
      'sentence': 'She have a red dress.',
      'error': 'have',
      'correct': 'has'
    },
    {
      'sentence': 'They is playing in the park.',
      'error': 'is',
      'correct': 'are'
    },
    {
      'sentence': 'The dog chase the cat.',
      'error': 'chase',
      'correct': 'chased'
    },
  ];

  int _currentIndex = 0;
  String? _selectedWord;

  void _checkAnswer() {
    final current = _questions[_currentIndex];
    bool isCorrect = _selectedWord == current['error'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Incorrect'),
        content: Text(
            isCorrect ?
            'Correct word is: ${current['correct']}' :
            'Incorrect. The error was: ${current['error']}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (_currentIndex < _questions.length - 1) {
                  _currentIndex++;
                } else {
                  _currentIndex = 0;
                }
                _selectedWord = null;
              });
            },
            child: Text('Next'),
          )
        ],
      ),
    );
  }

  List<String> _getWords(String sentence) {
    return sentence.replaceAll('.', '').split(' ');
  }

  @override
  Widget build(BuildContext context) {
    final current = _questions[_currentIndex];
    final words = _getWords(current['sentence']);

    return Scaffold(
      appBar: AppBar(title: Text('Error Spotting')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tap the word that contains an error:',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: words.map((word) {
                final isSelected = word == _selectedWord;
                return ChoiceChip(
                  label: Text(word),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedWord = word;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectedWord != null ? _checkAnswer : null,
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
