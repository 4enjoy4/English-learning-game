import 'package:flutter/material.dart';

class GamePlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String gameName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Game';

    return Scaffold(
      appBar: AppBar(title: Text(gameName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 100, color: Colors.grey[600]),
              SizedBox(height: 24),
              Text(
                '$gameName is coming soon!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'We\'re working hard to bring this game to life. Stay tuned!',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You will be notified when "$gameName" is available!'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                icon: Icon(Icons.notifications_active),
                label: Text('Notify Me'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
