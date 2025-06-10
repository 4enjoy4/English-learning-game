import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart';

class ErrorSpottingGame extends StatefulWidget {
  const ErrorSpottingGame({super.key});

  @override
  State<ErrorSpottingGame> createState() => _ErrorSpottingGameState();
}

class _ErrorSpottingGameState extends State<ErrorSpottingGame> {
  final List<String> sentences = [
    "She go to school every day.",
    "I has a pet cat.",
    "They is playing outside.",
    "He eat an apple.",
    "We was happy."
  ];

  final List<String> corrected = [
    "She goes to school every day.",
    "I have a pet cat.",
    "They are playing outside.",
    "He eats an apple.",
    "We were happy."
  ];

  int currentIndex = 0;
  int mistakeCount = 0;
  bool gameCompleted = false;

  final TextEditingController _controller = TextEditingController();

  String _normalize(String input) {
    return input.trim().toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
  }

  void _checkAnswer(String input, UserDataService userData) {
    final cleanedInput = _normalize(input);
    final correctAnswer = _normalize(corrected[currentIndex]);

    if (cleanedInput == correctAnswer) {
      setState(() {
        currentIndex++;
        if (currentIndex >= sentences.length) {
          gameCompleted = true;

          // Reward XP based on mistakes
          int earnedXP;
          if (mistakeCount <= 1) {
            earnedXP = 25;
          } else if (mistakeCount <= 3) {
            earnedXP = 20;
          } else {
            earnedXP = 15;
          }

          userData.addXP(earnedXP);

          // Show XP message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You earned $earnedXP XP!')),
          );
        }
      });
    } else {
      mistakeCount++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect. Try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Error Spotting')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: gameCompleted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Well done! You completed the game.',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                  mistakeCount = 0;
                  gameCompleted = false;
                  _controller.clear();
                });
              },
              child: const Text('Play Again'),
            )
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fix this sentence:',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(sentences[currentIndex],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Correct Sentence',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkAnswer(_controller.text, userData);
                _controller.clear();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
