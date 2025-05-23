import 'package:flutter/material.dart';

class FillInTheBlankGame extends StatefulWidget {
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

  void _submitAnswer() {
    if (_selectedOption == null) return;
    setState(() {
      _answered = true;
      _isCorrect = _selectedOption == _questions[_currentIndex]['answer'];
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _questions.length;
      _selectedOption = null;
      _answered = false;
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var question = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Fill in the Blank Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complete the sentence:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Text(
              question['sentence'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
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
                  title: Text(option, style: TextStyle(fontSize: 18)),
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
            SizedBox(height: 20),
            if (!_answered)
              ElevatedButton(
                onPressed: _selectedOption == null ? null : _submitAnswer,
                child: Text('Submit'),
              ),
            if (_answered)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isCorrect ? 'Correct!' : 'Wrong! The right answer is: ${question['answer']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text('Next'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
