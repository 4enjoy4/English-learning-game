import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int userLevel = 3;
  final int userXP = 750;
  final int userCoins = 120;

  final List<Achievement> achievements = [
    Achievement(title: 'First Steps', description: 'Completed your first lesson', unlocked: true),
    Achievement(title: 'Rising Star', description: 'Reached Level 2', unlocked: true),
    Achievement(title: 'Dedicated Learner', description: 'Completed 10 lessons', unlocked: false),
    Achievement(title: 'Coin Collector', description: 'Earned 100 coins', unlocked: true),
    Achievement(title: 'Halfway There', description: 'Reached Level 5', unlocked: false),
    Achievement(title: 'Master Mind', description: 'Completed all games', unlocked: false),
  ];

  ProfileScreen({super.key});

  String getLevelLabel(int level) {
    switch (level) {
      case 1:
        return 'A1 - Beginner';
      case 2:
        return 'A2 - Elementary';
      case 3:
        return 'B1 - Intermediate';
      case 4:
        return 'B2 - Upper Intermediate';
      case 5:
        return 'C1 - Advanced';
      case 6:
        return 'C2 - Proficient';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width < 400 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: size.width * 0.25,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  'M',
                  style: TextStyle(
                    fontSize: size.width * 0.25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Maksat Serikuly',
                style: TextStyle(
                  fontSize: size.width * 0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                getLevelLabel(userLevel),
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Level Progress',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: userXP / 1000,
                minHeight: 12,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 8),
              Text(
                '$userXP / 1000 XP',
                style: TextStyle(fontSize: size.width * 0.04),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber, size: size.width * 0.08),
                  const SizedBox(width: 8),
                  Text(
                    '$userCoins Coins',
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: achievements.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final ach = achievements[index];
                  return Card(
                    elevation: 3,
                    color: ach.unlocked ? Colors.lightGreen[100] : Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ach.unlocked ? Icons.emoji_events : Icons.lock,
                            color: ach.unlocked ? Colors.green[700] : Colors.grey[700],
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              ach.title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13, //Caused overflow errors
                                color: ach.unlocked ? Colors.green[900] : Colors.grey[700],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              ach.description,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 9, //Caused overflow errors
                                color: ach.unlocked ? Colors.green[800] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final bool unlocked;

  Achievement({
    required this.title,
    required this.description,
    this.unlocked = false,
  });
}
