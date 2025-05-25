import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  final int currentLevel;
  final int currentXP;
  final int xpForNextLevel;

  // List of rewards for each level milestone
  final List<LevelReward> rewards = [
    LevelReward(level: 1, title: 'Beginner Badge', icon: Icons.star_border),
    LevelReward(level: 2, title: 'Rising Star', icon: Icons.star_half),
    LevelReward(level: 3, title: 'Intermediate Badge', icon: Icons.star),
    LevelReward(level: 4, title: 'Advanced Learner', icon: Icons.emoji_events),
    LevelReward(level: 5, title: 'Expert Badge', icon: Icons.workspace_premium),
    LevelReward(level: 6, title: 'Master', icon: Icons.whatshot),
  ];

  ProgressScreen({
    Key? key,
    this.currentLevel = 3,
    this.currentXP = 750,
    this.xpForNextLevel = 1000,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercent = currentXP / xpForNextLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level $currentLevel',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'XP: $currentXP / $xpForNextLevel',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),

            // Fancy progress bar with level steps
            _buildLevelStepper(context),

            const SizedBox(height: 24),

            // Linear progress indicator for current XP in level
            LinearProgressIndicator(
              value: progressPercent,
              minHeight: 14,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blueAccent,
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                '${(progressPercent * 100).toStringAsFixed(1)}% to next level',
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Upcoming Rewards',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: rewards
                    .where((r) => r.level > currentLevel)
                    .map((reward) => ListTile(
                  leading: Icon(reward.icon, color: Colors.blueAccent),
                  title: Text(reward.title),
                  subtitle: Text('Reach level ${reward.level} to unlock'),
                  trailing: Icon(Icons.lock, color: Colors.grey),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelStepper(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rewards.map((reward) {
        final isUnlocked = reward.level <= currentLevel;

        return Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: isUnlocked ? Colors.blueAccent : Colors.grey.shade300,
              child: Icon(
                reward.icon,
                color: isUnlocked ? Colors.white : Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lv ${reward.level}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.blueAccent : Colors.grey,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class LevelReward {
  final int level;
  final String title;
  final IconData icon;

  LevelReward({
    required this.level,
    required this.title,
    required this.icon,
  });
}
