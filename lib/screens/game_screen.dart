import 'package:flutter/material.dart';

import '../games/error_spotting_game.dart';
import '../games/fill_in_the_blank_game.dart';
import '../games/guess_word_game.dart';
import '../games/sentence_jumble_game.dart';
import '../games/spelling_bee_game.dart';
import '../games/synonym_antonym_quiz_game.dart';
import '../games/word_match_game.dart';

class GamesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {
      'title': 'Word Match',
      'icon': 'assets/images/word_match.png',
      'page': WordMatchGame(),
    },
    {
      'title': 'Guess the Word',
      'icon': 'assets/images/guess_word.png',
      'page': GuessWordGame(),
    },
    {
      'title': 'Spelling Bee',
      'icon': 'assets/images/spelling_bee.png',
      'page': SpellingBeeGame(),
    },
    {
      'title': 'Synonym/Antonym Quiz',
      'icon': 'assets/images/synonym_antonym.png',
      'page': SynonymAntonymQuiz(),
    },
    {
      'title': 'Error Spotting',
      'icon': 'assets/images/error_spotting.png',
      'page': ErrorSpottingGame(),
    },
    {
      'title': 'Sentence Jumble',
      'icon': 'assets/images/sentence_jumble.png',
      'page': SentenceJumbleGame(),
    },
    {
      'title': 'Fill in the Blank',
      'icon': 'assets/images/fill_in_blank.png',
      'page': FillInTheBlankGame(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Games')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final game = games[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => game['page']));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          game['icon'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        game['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
