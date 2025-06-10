import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String title;
  final String description;
  bool unlocked;

  Achievement({
    required this.title,
    required this.description,
    this.unlocked = false,
  });

  // For persistence, we might want to convert achievements to/from Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'unlocked': unlocked,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      title: map['title'],
      description: map['description'],
      unlocked: map['unlocked'] ?? false,
    );
  }
}

class LevelReward {
  final int level;
  final String title;
  final IconData icon;

  const LevelReward({
    required this.level,
    required this.title,
    required this.icon,
  });
}

class UserDataService extends ChangeNotifier {
  static const String _levelKey = 'user_level';
  static const String _xpKey = 'user_xp';
  static const String _coinsKey = 'user_coins';
  static const String _achievementsKey = 'user_achievements';

  int level = 1;
  int xp = 0;
  int coins = 0;

  final List<Achievement> achievements = [
    Achievement(title: 'First Steps', description: 'Completed your first lesson'),
    Achievement(title: 'Rising Star', description: 'Reached Level 2'),
    Achievement(title: 'Dedicated Learner', description: 'Completed 10 lessons'),
    Achievement(title: 'Coin Collector', description: 'Earned 100 coins'),
    Achievement(title: 'Halfway There', description: 'Reached Level 5'),
    Achievement(title: 'Master Mind', description: 'Completed all games'),
  ];

  final List<LevelReward> rewards = const [
    LevelReward(level: 1, title: 'Beginner Badge', icon: Icons.star_border),
    LevelReward(level: 2, title: 'Rising Star', icon: Icons.star_half),
    LevelReward(level: 3, title: 'Intermediate Badge', icon: Icons.star),
    LevelReward(level: 4, title: 'Advanced Learner', icon: Icons.emoji_events),
    LevelReward(level: 5, title: 'Expert Badge', icon: Icons.workspace_premium),
    LevelReward(level: 6, title: 'Master', icon: Icons.whatshot),
  ];

  UserDataService() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    level = prefs.getInt(_levelKey) ?? 1;
    xp = prefs.getInt(_xpKey) ?? 0;
    coins = prefs.getInt(_coinsKey) ?? 0;

    // Load achievements unlocked states
    final unlockedList = prefs.getStringList(_achievementsKey) ?? [];
    for (var achievement in achievements) {
      achievement.unlocked = unlockedList.contains(achievement.title);
    }

    notifyListeners();
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, level);
    await prefs.setInt(_xpKey, xp);
    await prefs.setInt(_coinsKey, coins);

    // Save unlocked achievements by title
    final unlockedTitles = achievements
        .where((a) => a.unlocked)
        .map((a) => a.title)
        .toList();
    await prefs.setStringList(_achievementsKey, unlockedTitles);
  }

  void addXP(int amount) {
    xp += amount;
    while (xp >= 1000) {
      xp -= 1000;
      level++;
      _checkLevelAchievements();
    }
    _saveUserData();
    notifyListeners();
  }

  void removeXP(int amount) {
    xp -= amount;
    if (xp < 0) xp = 0;
    _saveUserData();
    notifyListeners();
  }

  void addCoins(int amount) {
    coins += amount;
    _checkCoinAchievements();
    _saveUserData();
    notifyListeners();
  }

  void _checkLevelAchievements() {
    if (level >= 2) _unlock('Rising Star');
    if (level >= 5) _unlock('Halfway There');
  }

  void _checkCoinAchievements() {
    if (coins >= 100) _unlock('Coin Collector');
  }

  void _unlock(String title) {
    for (var a in achievements) {
      if (a.title == title && !a.unlocked) {
        a.unlocked = true;
      }
    }
  }
}
