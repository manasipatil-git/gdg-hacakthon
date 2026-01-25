import 'package:flutter/material.dart';

class LeaderboardPreview extends StatelessWidget {
  const LeaderboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/leaderboard');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const ListTile(
          leading: CircleAvatar(child: Text('P')),
          title: Text('Priya S.'),
          trailing: Text('2340 pts'),
        ),
        const ListTile(
          leading: CircleAvatar(child: Text('R')),
          title: Text('Rahul (You)'),
          trailing: Text('1250 pts'),
        ),
      ],
    );
  }
}
