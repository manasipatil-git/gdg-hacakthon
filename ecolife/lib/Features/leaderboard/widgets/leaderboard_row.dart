import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final int score;

  const LeaderboardRow({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        rank.toString().padLeft(2, '0'),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      title: Text(name),
      subtitle: Text('$score points'),
      trailing: const Icon(Icons.emoji_events),
    );
  }
}
