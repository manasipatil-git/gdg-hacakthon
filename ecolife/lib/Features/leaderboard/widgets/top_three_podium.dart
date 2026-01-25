import 'package:flutter/material.dart';

class TopThreePodium extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const TopThreePodium({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _podium(users[1], 2),
        _podium(users[0], 1, isWinner: true),
        _podium(users[2], 3),
      ],
    );
  }

  Widget _podium(
    Map<String, dynamic> user,
    int rank, {
    bool isWinner = false,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: isWinner ? 28 : 24,
          child: Text(user['name'][0]),
        ),
        const SizedBox(height: 8),
        Container(
          height: isWinner ? 120 : 90,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text('$rank'),
        ),
      ],
    );
  }
}
