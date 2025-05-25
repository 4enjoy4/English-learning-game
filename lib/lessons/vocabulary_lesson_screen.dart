import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VocabularyLessonScreen extends StatefulWidget {
  const VocabularyLessonScreen({super.key});

  @override
  State<VocabularyLessonScreen> createState() => _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState extends State<VocabularyLessonScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _wordData;
  String? _wordImageUrl;
  String searchQuery = '';
  String? selectedCategory;

  final Map<String, List<String>> wordGroups = {
    'Animals': ['ant', 'bear', 'cat', 'dog', 'elephant', 'fox', 'giraffe', 'horse'],
    'Food': ['apple', 'banana', 'bread', 'carrot', 'donut', 'egg', 'fish', 'grape'],
    'Furniture': ['armchair', 'bed', 'cabinet', 'desk', 'end table', 'futon', 'lamp'],
    'Nature': ['tree', 'flower', 'river', 'mountain', 'forest', 'ocean', 'sky'],
    'Technology': ['computer', 'keyboard', 'mouse', 'monitor', 'smartphone', 'router'],
    'Clothing': ['shirt', 'pants', 'jacket', 'shoes', 'hat', 'socks', 'scarf'],
  };

  // Fetch image URL from Wikimedia API for better image chances
  Future<String?> fetchImageUrl(String query) async {
    try {
      final url =
          'https://en.wikipedia.org/w/api.php?action=query&titles=$query&prop=pageimages&format=json&pithumbsize=300';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pages = data['query']['pages'] as Map<String, dynamic>;
        if (pages.isNotEmpty) {
          final page = pages.values.first;
          if (page['thumbnail'] != null && page['thumbnail']['source'] != null) {
            return page['thumbnail']['source'];
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> fetchWordData(String word) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _wordData = null;
      _wordImageUrl = null;
    });

    try {
      final response =
      await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final imageUrl = await fetchImageUrl(word);
        setState(() {
          _wordData = data[0];
          _wordImageUrl = imageUrl;
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_wordImageUrl != null)
            Image.network(
              _wordImageUrl!,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          const SizedBox(height: 16),
          Text(
            _wordData!['word'] ?? '',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (final meaning in meanings)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meaning['partOfSpeech'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                _wordData = null;
                _wordImageUrl = null;
              });
            },
            child: const Text('Back to Categories'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryWords() {
    final words = wordGroups[selectedCategory]!
        .where((word) => word.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
      ..sort();

    // Map of word to its icon asset path (for demo, add your assets accordingly)
    final Map<String, String> wordIcons = {
      // Animals
      'ant': 'assets/images/lessons_vocabulary_categories/icons/animals/ant.png',
      'bear': 'assets/images/lessons_vocabulary_categories/icons/animals/bear.png',
      'cat': 'assets/images/lessons_vocabulary_categories/icons/animals/cat.png',
      'dog': 'assets/images/lessons_vocabulary_categories/icons/animals/dog.png',
      'elephant': 'assets/images/lessons_vocabulary_categories/icons/animals/elephant.png',
      'fox': 'assets/images/lessons_vocabulary_categories/icons/animals/fox.png',
      'giraffe': 'assets/images/lessons_vocabulary_categories/icons/animals/giraffe.png',
      'horse': 'assets/images/lessons_vocabulary_categories/icons/animals/horse.png',

      // Food
      'apple': 'assets/images/lessons_vocabulary_categories/icons/food/apple.png',
      'banana': 'assets/images/lessons_vocabulary_categories/icons/food/banana.png',
      'bread': 'assets/images/lessons_vocabulary_categories/icons/food/bread.png',
      'carrot': 'assets/images/lessons_vocabulary_categories/icons/food/carrots.png',
      'donut': 'assets/images/lessons_vocabulary_categories/icons/food/donut.png',
      'egg': 'assets/images/lessons_vocabulary_categories/icons/food/eggs.png',
      'fish': 'assets/images/lessons_vocabulary_categories/icons/food/fish.png',
      'grape': 'assets/images/lessons_vocabulary_categories/icons/food/grape.png',

      // Furniture
      'armchair': 'assets/images/lessons_vocabulary_categories/icons/furniture/armchair.png',
      'bed': 'assets/images/lessons_vocabulary_categories/icons/furniture/sleeping-beds.png',
      'cabinet': 'assets/images/lessons_vocabulary_categories/icons/furniture/kitchen.png',
      'desk': 'assets/images/lessons_vocabulary_categories/icons/furniture/desk.png',
      'end table': 'assets/images/lessons_vocabulary_categories/icons/furniture/table.png',
      'futon': 'assets/images/lessons_vocabulary_categories/icons/furniture/futon.png',
      'lamp': 'assets/images/lessons_vocabulary_categories/icons/furniture/table-lamp.png',

      // Nature
      'tree': 'assets/images/lessons_vocabulary_categories/icons/nature/tree.png',
      'flower': 'assets/images/lessons_vocabulary_categories/icons/nature/tulips.png',
      'river': 'assets/images/lessons_vocabulary_categories/icons/nature/creek.png',
      'mountain': 'assets/images/lessons_vocabulary_categories/icons/nature/mountain.png',
      'forest': 'assets/images/lessons_vocabulary_categories/icons/nature/forest.png',
      'ocean': 'assets/images/lessons_vocabulary_categories/icons/nature/ocean.png',
      'sky': 'assets/images/lessons_vocabulary_categories/icons/nature/cloud.png',

      // Technology
      'computer': 'assets/images/lessons_vocabulary_categories/icons/technology/computer.png',
      'keyboard': 'assets/images/lessons_vocabulary_categories/icons/technology/keyboard.png',
      'mouse': 'assets/images/lessons_vocabulary_categories/icons/technology/mouse.png',
      'monitor': 'assets/images/lessons_vocabulary_categories/icons/technology/desktop.png',
      'smartphone': 'assets/images/lessons_vocabulary_categories/icons/technology/smartphone.png',
      'router': 'assets/images/lessons_vocabulary_categories/icons/technology/wireless-router.png',

      // Clothing
      'shirt': 'assets/images/lessons_vocabulary_categories/icons/clothing/cloth.png',
      'pants': 'assets/images/lessons_vocabulary_categories/icons/clothing/jeans.png',
      'jacket': 'assets/images/lessons_vocabulary_categories/icons/clothing/jacket.png',
      'shoes': 'assets/images/lessons_vocabulary_categories/icons/clothing/sneakers.png',
      'hat': 'assets/images/lessons_vocabulary_categories/icons/clothing/graduation-hat.png',
      'socks': 'assets/images/lessons_vocabulary_categories/icons/clothing/socks.png',
      'scarf': 'assets/images/lessons_vocabulary_categories/icons/clothing/scarf.png',
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$selectedCategory Vocabulary',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // Removed big background image here
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: words.map((word) {
                final iconPath = wordIcons[word.toLowerCase()];
                return GestureDetector(
                  onTap: () => fetchWordData(word),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      border: Border.all(color: Colors.black54),
                      // No borderRadius -> boxed shape
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (iconPath != null)
                          Opacity(
                            opacity: 0.15,
                            child: Image.asset(
                              iconPath,
                              fit: BoxFit.contain,
                              width: 60,
                              height: 60,
                              color: Colors.black54,
                            ),
                          ),
                        Text(
                          word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => setState(() => selectedCategory = null),
            child: const Text('Back to Categories'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final Map<String, String> categoryImages = {
      'Animals': 'assets/images/lessons_vocabulary_categories/animals.png',
      'Food': 'assets/images/lessons_vocabulary_categories/food.png',
      'Furniture': 'assets/images/lessons_vocabulary_categories/furniture.png',
      'Nature': 'assets/images/lessons_vocabulary_categories/nature.png',
      'Technology': 'assets/images/lessons_vocabulary_categories/technology.png',
      'Clothing': 'assets/images/lessons_vocabulary_categories/clothing.png',
    };

    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: wordGroups.keys.map((category) {
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = category),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(categoryImages[category]!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 4),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vocabulary Builder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search vocabulary',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value.trim()),
              onSubmitted: (value) {
                if (value.isNotEmpty) fetchWordData(value.trim());
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
                : _wordData != null
                ? _buildWordContent()
                : selectedCategory != null
                ? _buildCategoryWords()
                : _buildCategoryGrid(),
          ),
        ],
      ),
    );
  }
}
