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

    await _db.collection('daily_logs').doc('$_uid\_$today').set({
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
}
