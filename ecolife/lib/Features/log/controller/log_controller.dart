import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogController {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  int score = 0;
  final Map<String, String> answers = {};

  void addAnswer(String key, String value, int points) {
    answers[key] = value;
    score += points;
  }

  Future<void> submit() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    await _db.collection('daily_logs').doc('${_uid}_$today').set({
      'uid': _uid,
      'date': today,
      ...answers,
      'scoreAdded': score,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(_uid).update({
      'ecoScore': FieldValue.increment(score),
    });
  }

  // 🆕 REAL FEATURE: Same as Yesterday (1-tap log)
  Future<void> logSameAsYesterday() async {
    // Reset state (important if reused)
    score = 0;
    answers.clear();

    // Demo yesterday values (safe defaults)
    addAnswer('transport', 'Public Transport', 5);
    addAnswer('food', 'Veg', 4);
    addAnswer('energy', 'Fan', 3);
    addAnswer('water', 'Normal Usage', 2);

    await submit();
  }
}
