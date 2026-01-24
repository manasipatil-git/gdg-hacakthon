import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Alice'),
            trailing: Text('120 pts'),
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Bob'),
            trailing: Text('100 pts'),
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('You'),
            trailing: Text('90 pts'),
          ),
        ],
      ),
    );
  }
}
