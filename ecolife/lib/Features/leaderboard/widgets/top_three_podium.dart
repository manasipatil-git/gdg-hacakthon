import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/colors.dart';

class TopThreePodium extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const TopThreePodium({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (users.length >= 2)
            Expanded(
              child: _podium(
                users[1],
                rank: 2,
                isYou: users[1]['uid'] == uid,
              ),
            ),

          if (users.isNotEmpty)
            Expanded(
              child: _podium(
                users[0],
                rank: 1,
                isWinner: true,
                isYou: users[0]['uid'] == uid,
              ),
            ),

          if (users.length >= 3)
            Expanded(
              child: _podium(
                users[2],
                rank: 3,
                isYou: users[2]['uid'] == uid,
              ),
            ),
        ],
      ),
    );
  }

  Widget _podium(
    Map<String, dynamic> user, {
    required int rank,
    bool isWinner = false,
    bool isYou = false,
  }) {
    final podiumHeight = isWinner ? 135.0 : rank == 2 ? 110.0 : 95.0;

    Color accent;
    switch (rank) {
      case 1:
        accent = AppColors.primary;
        break;
      case 2:
        accent = AppColors.primary.withOpacity(0.7);
        break;
      case 3:
        accent = AppColors.primary.withOpacity(0.5);
        break;
      default:
        accent = AppColors.primary;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Avatar
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: isWinner ? 30 : 26,
              backgroundColor: accent.withOpacity(0.15),
              child: Text(
                (user['name'] ?? 'U')[0].toUpperCase(),
                style: TextStyle(
                  fontSize: isWinner ? 22 : 18,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ),

            if (isWinner)
              Positioned(
                top: -10,
                right: -6,
                child: Icon(
                  Icons.emoji_events,
                  color: accent,
                  size: 20,
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        // Name
        Text(
          isYou ? 'You' : (user['name'] ?? 'User'),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 6),

        // Podium
        Container(
          height: podiumHeight,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            border: Border.all(
              color: accent.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${user['ecoScore'] ?? 0}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
