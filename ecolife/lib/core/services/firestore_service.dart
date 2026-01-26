import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ─────────────────────────────
   USER / AUTH RELATED
  ───────────────────────────── */

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'college': '',
      'hostel': '',
      'ecoScore': 0, // ✅ SINGLE SOURCE OF TRUTH
      'currentStreak': 0,
      'avgScore': 0,
      'onboardingCompleted': false,
      'leaderboardOptIn': true,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> isOnboardingCompleted(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['onboardingCompleted'] ?? false;
  }

  Future<void> completeOnboarding(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update({
      ...data,
      'onboardingCompleted': true,
    });
  }

  Future<UserModel> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('User not found');
    }

    final data = doc.data()!;

    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      ecoScore: data['ecoScore'] ?? 0,
      streak: data['currentStreak'] ?? 0,
    );
  }

  Future<String> getUserName(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['name'] ?? '';
  }

  /* ─────────────────────────────
   ECO LIFE CORE LOGIC
  ───────────────────────────── */

  Future<void> addTestTrip(String uid) async {
    try {
      debugPrint("🚀 addTestTrip START for uid: $uid");

      final today = DateTime.now().toIso8601String().split('T')[0];

      final dailyLogRef = _db
          .collection('dailyLogs')
          .doc(uid)
          .collection('logs')
          .doc(today);

      // 1️⃣ Ensure daily log
      await dailyLogRef.set({
        'date': today,
        'createdAt': FieldValue.serverTimestamp(),
        'totalDayEmissions': 0,
        'dailyScore': 0,
        'pointsEarned': 0,
      }, SetOptions(merge: true));

      // 2️⃣ Add eco-friendly trip
      await dailyLogRef.update({
        'trips': FieldValue.arrayUnion([
          {
            'mode': 'bus',
            'distanceKm': 5,
            'emissions': 1,
            'timestamp': Timestamp.now(),
          }
        ]),
        'totalDayEmissions': FieldValue.increment(1),
      });

      // 3️⃣ Calculate score
      final snapshot = await dailyLogRef.get();
      final totalEmissions = snapshot.data()?['totalDayEmissions'] ?? 0;

      final num dailyScore =
          (100 - (totalEmissions * 10)).clamp(0, 100);

      int points = 0;
      if (dailyScore >= 85) {
        points = 10;
      } else if (dailyScore >= 70) {
        points = 5;
      }

      // 4️⃣ Update daily log
      await dailyLogRef.update({
        'dailyScore': dailyScore,
        'pointsEarned': points,
      });

      // 5️⃣ UPDATE USER ecoScore (THIS IS THE KEY)
      await _db.collection('users').doc(uid).set({
        'ecoScore': FieldValue.increment(points),
      }, SetOptions(merge: true));

      debugPrint("🔥 ecoScore incremented by $points");
    } catch (e) {
      debugPrint("❌ addTestTrip FAILED: $e");
    }
  }
}
