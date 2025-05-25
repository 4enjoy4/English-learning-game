import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrammarLessonScreen extends StatefulWidget {
  const GrammarLessonScreen({super.key});

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  Map<String, List<dynamic>> _grammarData = {};
  bool _isLoading = true;
  String? _error;

  bool _showCategory = false;
  String _selectedCategory = '';
  List<dynamic> _selectedRules = [];

  @override
  void initState() {
    super.initState();
    _loadGrammarData();
  }

  Future<void> _loadGrammarData() async {
    try {
      final jsonString =
      await rootBundle.loadString('assets/json_files/grammar_rules.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final grammarRules = jsonData['grammar_rules'] as Map<String, dynamic>;

      setState(() {
        _grammarData = grammarRules.map(
              (key, value) => MapEntry(key, List<dynamic>.from(value)),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load grammar data: $e';
        _isLoading = false;
      });
    }
  }

  void _selectCategory(String category, List<dynamic> rules) {
    setState(() {
      _selectedCategory = category;
      _selectedRules = rules;
      _showCategory = true;
    });
  }

  void _goBackToGrid() {
    setState(() {
      _showCategory = false;
      _selectedCategory = '';
      _selectedRules = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_showCategory
            ? _selectedCategory.toUpperCase()
            : 'Grammar Lessons'),
        leading: _showCategory
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToGrid,
        )
            : null,
      ),
      body: _showCategory
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _selectedRules.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final rule = _selectedRules[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rule['title'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  if (rule['example'] != null)
                    Text("Example: ${rule['example']}",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 14)),
                  const SizedBox(height: 8),
                  if (rule['explanation'] != null)
                    Text(rule['explanation'],
                        style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          );
        },
      )
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _grammarData.entries.map((entry) {
            final category = entry.key;
            final rules = entry.value;
            return GestureDetector(
              onTap: () => _selectCategory(category, rules),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.blue.shade50,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      category.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
