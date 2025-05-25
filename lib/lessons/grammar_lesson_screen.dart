import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrammarLessonScreen extends StatefulWidget {
  const GrammarLessonScreen({super.key});

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _wordData;

  Future<void> fetchWordData(String word) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _wordData = null;
    });

    try {
      final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _wordData = data[0];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Word not found.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildWordContent() {
    if (_wordData == null) return const SizedBox.shrink();

    final meanings = _wordData!['meanings'] as List<dynamic>;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          _wordData!['word'] ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (final meaning in meanings)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning['partOfSpeech'] ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              ...List.generate(
                meaning['definitions'].length,
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("- ${meaning['definitions'][i]['definition']}"),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Explorer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search Grammar Word (e.g., run, write)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) fetchWordData(value.trim());
              },
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          else
            Expanded(child: _buildWordContent()),
        ],
      ),
    );
  }
}
