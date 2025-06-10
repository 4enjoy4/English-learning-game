import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataService>(context);
    final progress = user.xp / 1000;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Level ${user.level}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('XP: ${user.xp} / 1000'),
            const SizedBox(height: 16),
            _buildLevelStepper(user.level, user.rewards),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress, minHeight: 14),
            Center(child: Text('${(progress * 100).toStringAsFixed(1)}% to next level')),
            const SizedBox(height: 30),
            const Text('Upcoming Rewards',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: user.rewards
                    .where((r) => r.level > user.level)
                    .map((r) => ListTile(
                  leading: Icon(r.icon, color: Colors.blueAccent),
                  title: Text(r.title),
                  subtitle: Text('Reach level ${r.level} to unlock'),
                  trailing: const Icon(Icons.lock, color: Colors.grey),
                ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLevelStepper(int currentLevel, List<LevelReward> rewards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rewards.map((reward) {
          final unlocked = reward.level <= currentLevel;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: unlocked ? Colors.blueAccent : Colors.grey.shade300,
                  child: Icon(reward.icon, color: unlocked ? Colors.white : Colors.grey),
                ),
                const SizedBox(height: 4),
                Text('Lv ${reward.level}',
                    style: TextStyle(
                        color: unlocked ? Colors.blueAccent : Colors.grey,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
