import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart';

class FillInTheBlankGame extends StatefulWidget {
  const FillInTheBlankGame({super.key});

  @override
  _FillInTheBlankGameState createState() => _FillInTheBlankGameState();
}

class _FillInTheBlankGameState extends State<FillInTheBlankGame> {
  final List<Map<String, dynamic>> _questions = [
    {
      'sentence': 'I ___ to the store yesterday.',
      'options': ['go', 'went', 'gone', 'going'],
      'answer': 'went',
    },
    {
      'sentence': 'She ___ a new car last week.',
      'options': ['buy', 'buys', 'bought', 'buying'],
      'answer': 'bought',
    },
    {
      'sentence': 'They have ___ the project already.',
      'options': ['finish', 'finished', 'finishing', 'finishes'],
      'answer': 'finished',
    },
  ];

  int _currentIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  bool _isCorrect = false;

  int _mistakeCount = 0;
  bool _gameCompleted = false;

  void _submitAnswer() {
    if (_selectedOption == null) return;

    setState(() {
      _answered = true;
      _isCorrect = _selectedOption == _questions[_currentIndex]['answer'];
      if (!_isCorrect) {
        _mistakeCount++;
      }
    });
  }

  void _nextQuestion(UserDataService userData) {
    if (_currentIndex == _questions.length - 1) {
      // Game finished, reward XP based on mistakes
      int earnedXP;
      if (_mistakeCount <= 1) {
        earnedXP = 25;
      } else if (_mistakeCount <= 3) {
        earnedXP = 20;
      } else {
        earnedXP = 15;
      }

      userData.addXP(earnedXP);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🎉 You earned $earnedXP XP!')),
      );

      setState(() {
        _gameCompleted = true;
      });
    } else {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
        _isCorrect = false;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _currentIndex = 0;
      _selectedOption = null;
      _answered = false;
      _isCorrect = false;
      _mistakeCount = 0;
      _gameCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);

    if (_gameCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Fill in the Blank Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text('Well done! You completed the game.',
                  style: TextStyle(fontSize: 20)),
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

    var question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Fill in the Blank Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Complete the sentence:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              question['sentence'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...question['options'].map<Widget>((option) {
              bool isSelected = option == _selectedOption;
              Color optionColor = Colors.blue.shade100;
              if (_answered) {
                if (option == question['answer']) {
                  optionColor = Colors.green.shade300;
                } else if (isSelected && !_isCorrect) {
                  optionColor = Colors.red.shade300;
                } else {
                  optionColor = Colors.grey.shade200;
                }
              } else if (isSelected) {
                optionColor = Colors.blue.shade300;
              }
              return Card(
                color: optionColor,
                child: ListTile(
                  title: Text(option, style: const TextStyle(fontSize: 18)),
                  onTap: _answered
                      ? null
                      : () {
                    setState(() {
                      _selectedOption = option;
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            if (!_answered)
              ElevatedButton(
                onPressed: _selectedOption == null ? null : _submitAnswer,
                child: const Text('Submit'),
              ),
            if (_answered)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isCorrect
                        ? 'Correct!'
                        : 'Wrong! The right answer is: ${question['answer']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _nextQuestion(userData),
                    child: const Text('Next'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
