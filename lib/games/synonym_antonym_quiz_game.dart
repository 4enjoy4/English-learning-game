import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart'; // adjust import path

class SynonymAntonymQuiz extends StatefulWidget {
  @override
  _SynonymAntonymQuizState createState() => _SynonymAntonymQuizState();
}

class _SynonymAntonymQuizState extends State<SynonymAntonymQuiz> {
  final FlutterTts flutterTts = FlutterTts();

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

  @override
  void initState() {
    super.initState();
    _speakCurrentQuestion();
  }

  Future<void> _speakCurrentQuestion() async {
    await flutterTts.stop();
    await flutterTts.speak(questions[currentQuestion]['question']);
  }

  void _submitAnswer(UserDataService userData) {
    bool isCorrect = selectedAnswer == questions[currentQuestion]['answer'];

    if (isCorrect) {
      score++;
    }

    // Award XP
    int earnedXP = isCorrect ? 25 : 15;
    userData.addXP(earnedXP);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You earned $earnedXP XP!')),
    );

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
      _speakCurrentQuestion();
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
              _speakCurrentQuestion();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);
    final current = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: Text('Synonym/Antonym Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(current['question'], style: TextStyle(fontSize: 20))),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: _speakCurrentQuestion,
                )
              ],
            ),
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
              onPressed: selectedAnswer == null ? null : () => _submitAnswer(userData),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
