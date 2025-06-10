import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_data_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        return 'Unknown Level';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataService>(context);
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width < 400 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: size.width * 0.25,
              backgroundColor: Colors.blueAccent,
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: size.width * 0.25 * 0.6,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Maksat Serikuly',
                style: TextStyle(fontSize: size.width * 0.07, fontWeight: FontWeight.bold)),
            Text(getLevelLabel(user.level),
                style: TextStyle(fontSize: size.width * 0.045, color: Colors.grey[600])),
            const SizedBox(height: 20),
            Text('Level Progress',
                style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: user.xp / 1000, minHeight: 12),
            const SizedBox(height: 4),
            Text('${user.xp} / 1000 XP',
                style: TextStyle(fontSize: size.width * 0.04)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 6),
                Text('${user.coins} Coins',
                    style: TextStyle(fontSize: size.width * 0.045, color: Colors.amber[800]))
              ],
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Achievements',
                  style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: user.achievements.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.7,
              ),
              itemBuilder: (context, index) {
                final ach = user.achievements[index];
                return Card(
                  color: ach.unlocked ? Colors.green[100] : Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ach.unlocked ? Icons.emoji_events : Icons.lock,
                          color: ach.unlocked ? Colors.green : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            ach.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.035,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            ach.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}
