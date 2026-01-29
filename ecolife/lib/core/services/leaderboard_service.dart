import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getLeaderboard() {
    return _db
        .collection('users')
        .orderBy('ecoScore', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return {
              'uid': doc.id,
              'name': data['name'] ?? 'User',
              'ecoScore': data['ecoScore'] ?? 0,
              'streak': data['currentStreak'] ?? 0,
            };
          }).toList();
        });
  }
}
