import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart'; // adjust path

class SpellingBeeGame extends StatefulWidget {
  @override
  _SpellingBeeGameState createState() => _SpellingBeeGameState();
}

class _SpellingBeeGameState extends State<SpellingBeeGame> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController controller = TextEditingController();

  // Hardcoded list of 45+ words
  final List<String> allWords = [
    'banana', 'computer', 'elephant', 'mountain', 'umbrella', 'guitar', 'puzzle', 'library',
    'notebook', 'window', 'keyboard', 'printer', 'bottle', 'teacher', 'student', 'bridge',
    'river', 'island', 'forest', 'camera', 'garden', 'pencil', 'painting', 'airplane',
    'school', 'doctor', 'market', 'city', 'flower', 'chocolate', 'diamond', 'rocket',
    'planet', 'sunshine', 'bicycle', 'cookie', 'diamond', 'dragon', 'elephant', 'festival',
    'garden', 'holiday', 'internet', 'jungle', 'kangaroo', 'lemonade', 'mountain', 'notebook',
    'ocean', 'pyramid'
  ];

  late List<String> roundWords; // The 4 words picked randomly for the round
  int currentWordIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    final random = Random();
    final picked = <String>{};

    // Pick 4 unique random words
    while (picked.length < 4) {
      picked.add(allWords[random.nextInt(allWords.length)]);
    }

    roundWords = picked.toList();
    currentWordIndex = 0;
    score = 0;
    controller.clear();
    setState(() {});
    // No speaking here! User must press play button to hear word
  }

  void _speakWord() async {
    await flutterTts.stop();
    await flutterTts.speak(roundWords[currentWordIndex]);
  }

  void _checkSpelling(UserDataService userData) {
    String input = controller.text.trim().toLowerCase();
    String correct = roundWords[currentWordIndex];
    bool isCorrect = input == correct;

    if (isCorrect) score++;

    if (currentWordIndex < roundWords.length - 1) {
      setState(() {
        currentWordIndex++;
        controller.clear();
      });
    } else {
      _awardXPAndShowResult(userData);
    }
  }

  void _awardXPAndShowResult(UserDataService userData) {
    // Example XP: 10 XP per correct word
    int earnedXP = score * 10;
    userData.addXP(earnedXP);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You earned $earnedXP XP!')),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Round Completed'),
        content: Text('Your score: $score / ${roundWords.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewRound();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Spelling Bee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Listen to the word and spell it correctly:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speakWord,
              child: Text('Play Word'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type the word',
              ),
              onSubmitted: (_) => _checkSpelling(userData),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkSpelling(userData),
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              'Word ${currentWordIndex + 1} of ${roundWords.length}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
