import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ─────────────────────────────
   USER / AUTH RELATED
  ───────────────────────────── */

  /// Create Firestore user on signup
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
      'totalPoints': 0, // ecoScore
      'currentStreak': 0, // streak
      'avgScore': 0,
      'onboardingCompleted': false,
      'leaderboardOptIn': true,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['onboardingCompleted'] ?? false;
  }

  /// Save onboarding data
  Future<void> completeOnboarding(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update({
      ...data,
      'onboardingCompleted': true,
    });
  }

  /// Fetch FULL user for Provider
  Future<UserModel> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('User not found');
    }

    final data = doc.data()!;

    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      ecoScore: data['totalPoints'] ?? 0,
      streak: data['currentStreak'] ?? 0,
    );
  }

  /// Fetch user name (used earlier)
  Future<String> getUserName(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (doc.exists && doc.data()?['name'] != null) {
      return doc.data()!['name'];
    }

    return '';
  }

  /* ─────────────────────────────
   ECO LIFE CORE LOGIC
  ───────────────────────────── */

  /// Add a test trip (DEMO / HACKATHON HAPPY PATH)
  Future<void> addTestTrip(String uid) async {
    try {
      debugPrint("🚀 addTestTrip START for uid: $uid");

      final today = DateTime.now().toIso8601String().split('T')[0];

      final dailyLogRef = _db
          .collection('dailyLogs')
          .doc(uid)
          .collection('logs')
          .doc(today);

      // 1️⃣ Ensure daily log exists
      await dailyLogRef.set({
        'date': today,
        'createdAt': FieldValue.serverTimestamp(),
        'totalDayEmissions': 0,
        'dailyScore': 0,
        'pointsEarned': 0,
      }, SetOptions(merge: true));

      debugPrint("✅ daily log ensured");

      // 2️⃣ Add trip
      await dailyLogRef.update({
        'trips': FieldValue.arrayUnion([
          {
            'mode': 'bus',
            'distanceKm': 5,
            'emissions': 5,
            'timestamp': Timestamp.now(),
          }
        ]),
        'totalDayEmissions': FieldValue.increment(5),
      });

      debugPrint("✅ trip added");

      // 3️⃣ Recalculate emissions & score
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

      debugPrint("🧮 dailyScore=$dailyScore | points=$points");

      // 4️⃣ Update daily score + points
      await dailyLogRef.update({
        'dailyScore': dailyScore,
        'pointsEarned': points,
      });

      debugPrint("✅ daily score updated");

      // 5️⃣ Update user ecoScore (totalPoints)
      await _db.collection('users').doc(uid).update({
        'totalPoints': FieldValue.increment(points),
      });

      debugPrint("🔥 totalPoints incremented by $points");
    } catch (e) {
      debugPrint("❌ addTestTrip FAILED: $e");
    }
  }
}
