import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';

class ListeningLessonScreen extends StatefulWidget {
  const ListeningLessonScreen({super.key});

  @override
  State<ListeningLessonScreen> createState() => _ListeningLessonScreenState();
}

class _ListeningLessonScreenState extends State<ListeningLessonScreen> {
  List<dynamic> lessons = [];
  int currentIndex = 0;
  bool isLoading = true;
  String? errorMessage;

  final FlutterTts flutterTts = FlutterTts();

  bool isPlaying = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _loadLessons();
    _initTts();
  }

  Future<void> _loadLessons() async {
    try {
      final String jsonString =
      await rootBundle.loadString('assets/json_files/listening_lessons.json');
      final Map<String, dynamic> data = json.decode(jsonString);

      if (data['lessons'] != null && data['lessons'] is List) {
        setState(() {
          lessons = data['lessons'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Invalid lesson format.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load lessons: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Select Siri-like voice if available (casting Map properly)
    List<dynamic>? voices = await flutterTts.getVoices;
    if (voices != null) {
      for (var voice in voices) {
        if (voice is Map) {
          final Map<String, String> voiceMap = Map<String, String>.from(voice);
          if (voiceMap['name']?.toLowerCase().contains('siri') ?? false) {
            await flutterTts.setVoice(voiceMap);
            break;
          }
        }
      }
    }

    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
        isPaused = false;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        isPlaying = false;
        isPaused = true;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    });
  }

  Future<void> _speak() async {
    if (lessons.isEmpty) return;
    var text = lessons[currentIndex]['text'] ?? '';
    if (text.isNotEmpty) {
      await flutterTts.stop();
      await flutterTts.speak(text);
    }
  }

  Future<void> _pause() async {
    await flutterTts.pause();
  }

  Future<void> _resume() async {
    // flutter_tts doesn't support resume natively on all platforms,
    // so here we just re-speak the current lesson text.
    if (isPaused) {
      await _speak();
    }
  }

  void _nextLesson() {
    if (lessons.isEmpty) return;
    flutterTts.stop();
    setState(() {
      currentIndex = (currentIndex + 1) % lessons.length;
      isPlaying = false;
      isPaused = false;
    });
  }

  void _prevLesson() {
    if (lessons.isEmpty) return;
    flutterTts.stop();
    setState(() {
      currentIndex = (currentIndex - 1 + lessons.length) % lessons.length;
      isPlaying = false;
      isPaused = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listening Lessons')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessons[currentIndex]['title'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  lessons[currentIndex]['text'] ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _prevLesson,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextLesson,
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  onPressed: isPlaying ? null : _speak,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  onPressed: isPlaying ? _pause : null,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Resume'),
                  onPressed: isPaused ? _resume : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
