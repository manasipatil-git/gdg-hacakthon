import 'package:flutter/material.dart';

class ProfileStatsRow extends StatelessWidget {
  final int followers;
  final int following;
  final int ecoCircle;

  const ProfileStatsRow({
    super.key,
    required this.followers,
    required this.following,
    required this.ecoCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatItem(
            label: 'Followers',
            value: followers,
          ),
          _StatItem(
            label: 'Following',
            value: following,
          ),
          _StatItem(
            label: 'Eco Circle',
            value: ecoCircle,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
