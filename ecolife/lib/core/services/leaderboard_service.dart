import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getLeaderboard() {
    return _db
        .collection('users')
        .orderBy('ecoScore', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }
}
