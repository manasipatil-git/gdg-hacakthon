import '../models/challenge_model.dart';

final List<Challenge> challengeDefinitions = [
  Challenge(
    id: 'energy_saver',
    title: 'Energy Saver',
    description: 'Low energy usage for 5 days',
    daysRequired: 5,
    reward: 175,
    difficulty: 'Medium',
  ),
  Challenge(
    id: 'bike_champion',
    title: 'Bike Champion',
    description: 'Cycle to campus for 14 days',
    daysRequired: 14,
    reward: 500,
    difficulty: 'Hard',
  ),
];
