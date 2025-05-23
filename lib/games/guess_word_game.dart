// guess_word_game.dart
import 'package:flutter/material.dart';

class GuessWordGame extends StatefulWidget {
  @override
  _GuessWordGameState createState() => _GuessWordGameState();
}

class _GuessWordGameState extends State<GuessWordGame> {
  final List<Map<String, dynamic>> _questions = [
    {
      'image': 'assets/images/guess_the_word_game/apple.png',
      'options': ['Banana', 'Apple', 'Orange'],
      'answer': 'Apple',
    },
    {
      'image': 'assets/images/guess_the_word_game/dog.png',
      'options': ['Cat', 'Dog', 'Mouse'],
      'answer': 'Dog',
    },
    {
      'image': 'assets/images/guess_the_word_game/car.png',
      'options': ['Bus', 'Car', 'Bike'],
      'answer': 'Car',
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String _selectedOption = '';

  void _checkAnswer(String selected) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOption = selected;
      if (selected == _questions[_currentIndex]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _answered = false;
      _selectedOption = '';
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _answered = false;
                _selectedOption = '';
              });
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Guess the Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(question['image'], height: 200),
            SizedBox(height: 24),
            ...question['options'].map<Widget>((option) {
              final isCorrect = option == question['answer'];
              final isSelected = option == _selectedOption;
              Color? color;
              if (_answered) {
                if (isSelected) {
                  color = isCorrect ? Colors.green : Colors.red;
                } else if (isCorrect) {
                  color = Colors.green;
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () => _checkAnswer(option),
                  child: Text(option),
                ),
              );
            }).toList(),
            SizedBox(height: 24),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(_currentIndex == _questions.length - 1
                    ? 'Finish'
                    : 'Next'),
              )
          ],
        ),
      ),
    );
  }
}
