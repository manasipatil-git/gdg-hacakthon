import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ─────────────────────────────
   USER / AUTH
  ───────────────────────────── */

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'ecoScore': 0,
      'currentStreak': 0,
      'lastLogDate': null,
      'onboardingCompleted': false,
      'leaderboardOptIn': true,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ✅ Complete onboarding (NO side effects)
  Future<void> completeOnboarding(
    String uid,
    Map<String, dynamic> onboardingData,
  ) async {
    await _db.collection('users').doc(uid).update({
      ...onboardingData,
      'onboardingCompleted': true,
    });
  }

  /// ✅ CHECK onboarding status (THIS FIXES YOUR ERROR)
  Future<bool> isOnboardingCompleted(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      return false;
    }

    return doc.data()!['onboardingCompleted'] == true;
  }

  /// ONE-TIME FETCH (used only where needed)
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

  /// 🔥 LIVE USER STREAM (streak + ecoScore live updates)
  Stream<UserModel> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        throw Exception('User not found');
      }

      return UserModel(
        uid: uid,
        name: data['name'] ?? '',
        ecoScore: data['ecoScore'] ?? 0,
        streak: data['currentStreak'] ?? 0,
      );
    });
  }

  /* ─────────────────────────────
   ECO ACTION + STREAK LOGIC
  ───────────────────────────── */

  Future<void> logEcoAction({
    required String uid,
    required int points,
    required String type,
  }) async {
    final userRef = _db.collection('users').doc(uid);
    final logRef = userRef.collection('logs').doc();

    final userSnap = await userRef.get();
    final data = userSnap.data();

    if (data == null) return;

    final today = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(today);
    final yesterdayKey =
        DateFormat('yyyy-MM-dd').format(today.subtract(const Duration(days: 1)));

    final String? lastLogDate = data['lastLogDate'];
    int currentStreak = data['currentStreak'] ?? 0;

    int updatedStreak;

    if (lastLogDate == todayKey) {
      updatedStreak = currentStreak;
    } else if (lastLogDate == yesterdayKey) {
      updatedStreak = currentStreak + 1;
    } else {
      updatedStreak = 1;
    }

    // Save log entry
    await logRef.set({
      'type': type,
      'points': points,
      'date': todayKey,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update user document
    await userRef.update({
      'ecoScore': FieldValue.increment(points),
      'currentStreak': updatedStreak,
      'lastLogDate': todayKey,
    });
  }

  /* ─────────────────────────────
   LEADERBOARD
  ───────────────────────────── */

  Stream<QuerySnapshot> leaderboardStream({int limit = 10}) {
    return _db
        .collection('users')
        .orderBy('ecoScore', descending: true)
        .limit(limit)
        .snapshots();
  }
}
