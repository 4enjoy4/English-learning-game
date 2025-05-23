import 'package:flutter/material.dart';

class SynonymAntonymQuiz extends StatefulWidget {
  @override
  _SynonymAntonymQuizState createState() => _SynonymAntonymQuizState();
}

class _SynonymAntonymQuizState extends State<SynonymAntonymQuiz> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Select the synonym for "Happy"',
      'options': ['Sad', 'Joyful', 'Angry', 'Tired'],
      'answer': 'Joyful',
    },
    {
      'question': 'Select the antonym for "Hot"',
      'options': ['Cold', 'Warm', 'Spicy', 'Humid'],
      'answer': 'Cold',
    },
    {
      'question': 'Select the synonym for "Fast"',
      'options': ['Slow', 'Rapid', 'Lazy', 'Silent'],
      'answer': 'Rapid',
    },
    {
      'question': 'Select the antonym for "Beautiful"',
      'options': ['Ugly', 'Pretty', 'Stunning', 'Graceful'],
      'answer': 'Ugly',
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  String? selectedAnswer;

  void _submitAnswer() {
    if (selectedAnswer == questions[currentQuestion]['answer']) {
      score++;
    }
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score: $score / ${questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                score = 0;
                selectedAnswer = null;
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
    final current = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: Text('Synonym/Antonym Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(current['question'], style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ...current['options'].map<Widget>((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedAnswer,
              onChanged: (value) {
                setState(() {
                  selectedAnswer = value;
                });
              },
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedAnswer == null ? null : _submitAnswer,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
