import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpellingBeeGame extends StatefulWidget {
  @override
  _SpellingBeeGameState createState() => _SpellingBeeGameState();
}

class _SpellingBeeGameState extends State<SpellingBeeGame> {
  final FlutterTts flutterTts = FlutterTts();
  final List<String> words = ['banana', 'computer', 'elephant', 'mountain', 'umbrella'];
  int currentWordIndex = 0;
  final TextEditingController controller = TextEditingController();
  int score = 0;

  void _speakWord() async {
    await flutterTts.speak(words[currentWordIndex]);
  }

  void _checkSpelling() {
    String input = controller.text.trim().toLowerCase();
    String correct = words[currentWordIndex];
    if (input == correct) {
      score++;
    }
    if (currentWordIndex < words.length - 1) {
      setState(() {
        currentWordIndex++;
        controller.clear();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score: $score / ${words.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentWordIndex = 0;
                score = 0;
                controller.clear();
              });
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
    return Scaffold(
      appBar: AppBar(title: Text('Spelling Bee')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Listen to the word and spell it correctly:', style: TextStyle(fontSize: 18)),
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
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkSpelling,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
