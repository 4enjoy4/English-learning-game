import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart'; // Adjust the import path as needed

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
  int _mistakeCount = 0;
  bool _answered = false;
  String _selectedOption = '';
  bool _gameCompleted = false;

  void _checkAnswer(String selected) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedOption = selected;
      if (selected == _questions[_currentIndex]['answer']) {
        _score++;
      } else {
        _mistakeCount++;
      }
    });
  }

  void _nextQuestion(UserDataService userData) {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _answered = false;
        _selectedOption = '';
        _currentIndex++;
      });
    } else {
      _finishGame(userData);
    }
  }

  void _finishGame(UserDataService userData) {
    int earnedXP;
    if (_mistakeCount <= 1) {
      earnedXP = 25;
    } else if (_mistakeCount <= 3) {
      earnedXP = 20;
    } else {
      earnedXP = 15;
    }

    userData.addXP(earnedXP);

    setState(() {
      _gameCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🎉 You earned $earnedXP XP!')),
    );
  }

  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _mistakeCount = 0;
      _answered = false;
      _selectedOption = '';
      _gameCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);

    if (_gameCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guess the Word')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                'Game completed!\nYour score: $_score / ${_questions.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetGame,
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(question['image'], height: 200),
            const SizedBox(height: 24),
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
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _checkAnswer(option),
                  child: Text(option),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            if (_answered)
              ElevatedButton(
                onPressed: () => _nextQuestion(userData),
                child: Text(
                  _currentIndex == _questions.length - 1 ? 'Finish' : 'Next',
                ),
              )
          ],
        ),
      ),
    );
  }
}
