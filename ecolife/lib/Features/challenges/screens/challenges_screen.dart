import 'package:flutter/material.dart';
import '../data/challenge_definitions.dart';
import '../widgets/challenge_card.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challengeDefinitions.length,
        itemBuilder: (context, index) {
          return ChallengeCard(
            challenge: challengeDefinitions[index],
          );
        },
      ),
    );
  }
}
