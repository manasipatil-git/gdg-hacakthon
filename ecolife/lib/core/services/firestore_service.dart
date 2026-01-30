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
      'following': <String>[],
      'followers': <String>[],
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> completeOnboarding(
    String uid,
    Map<String, dynamic> onboardingData,
  ) async {
    await _db.collection('users').doc(uid).update({
      ...onboardingData,
      'onboardingCompleted': true,
    });
  }

  Future<bool> isOnboardingCompleted(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return false;
    return doc.data()!['onboardingCompleted'] == true;
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

  Stream<UserModel> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) throw Exception('User not found');

      return UserModel(
        uid: uid,
        name: data['name'] ?? '',
        ecoScore: data['ecoScore'] ?? 0,
        streak: data['currentStreak'] ?? 0,
      );
    });
  }

  /* ─────────────────────────────
   FOLLOW / UNFOLLOW
  ───────────────────────────── */

  Future<void> followUser({
    required String currentUid,
    required String targetUid,
  }) async {
    final currentUserRef = _db.collection('users').doc(currentUid);
    final targetUserRef = _db.collection('users').doc(targetUid);

    await _db.runTransaction((tx) async {
      tx.update(currentUserRef, {
        'following': FieldValue.arrayUnion([targetUid]),
      });
      tx.update(targetUserRef, {
        'followers': FieldValue.arrayUnion([currentUid]),
      });
    });
  }

  Future<void> unfollowUser({
    required String currentUid,
    required String targetUid,
  }) async {
    final currentUserRef = _db.collection('users').doc(currentUid);
    final targetUserRef = _db.collection('users').doc(targetUid);

    await _db.runTransaction((tx) async {
      tx.update(currentUserRef, {
        'following': FieldValue.arrayRemove([targetUid]),
      });
      tx.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([currentUid]),
      });
    });
  }

  /* ─────────────────────────────
   🔥 SUGGESTED USERS (TOP RANKERS)
  ───────────────────────────── */

  Future<List<Map<String, dynamic>>> getSuggestedUsers({
    required String currentUid,
    int limit = 5,
  }) async {
    final currentUserDoc =
        await _db.collection('users').doc(currentUid).get();

    final List<String> alreadyFollowing =
        List<String>.from(currentUserDoc.data()?['following'] ?? []);

    final snapshot = await _db
        .collection('users')
        .orderBy('ecoScore', descending: true)
        .limit(limit + 5)
        .get();

    final users = snapshot.docs
        .where((doc) =>
            doc.id != currentUid &&
            !alreadyFollowing.contains(doc.id))
        .map((doc) => {
              'uid': doc.id,
              ...doc.data(),
            })
        .take(limit)
        .toList();

    return users;
  }

  /* ─────────────────────────────
   🔍 SEARCH USERS BY NAME
  ───────────────────────────── */

  Future<List<Map<String, dynamic>>> searchUsersByName({
    required String query,
    required String currentUid,
    int limit = 10,
  }) async {
    if (query.isEmpty) return [];

    final snapshot = await _db
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(limit)
        .get();

    return snapshot.docs
        .where((doc) => doc.id != currentUid)
        .map((doc) => {
              'uid': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  /* ─────────────────────────────
   🌱 CREATE ECOCIRCLE (NEW)
  ───────────────────────────── */

  Future<void> createEcoCircle({
    required String name,
    required List<String> memberUids,
    required String createdBy,
  }) async {
    await _db.collection('ecoCircles').add({
      'name': name,
      'members': memberUids,
      'createdBy': createdBy,
      'circleStreak': 0,
      'createdAt': FieldValue.serverTimestamp(),
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

    await logRef.set({
      'type': type,
      'points': points,
      'date': todayKey,
      'createdAt': FieldValue.serverTimestamp(),
    });

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

  /* ─────────────────────────────
   REWARDS
  ───────────────────────────── */

  Future<void> redeemReward({
    required String uid,
    required int pointsRequired,
    required String rewardId,
    required String rewardName,
  }) async {
    final userRef = _db.collection('users').doc(uid);

    await _db.runTransaction((transaction) async {
      final userSnap = await transaction.get(userRef);
      if (!userSnap.exists) throw Exception('User not found');

      final currentScore = userSnap['ecoScore'] ?? 0;
      if (currentScore < pointsRequired) {
        throw Exception('Not enough EcoScore');
      }

      transaction.update(userRef, {
        'ecoScore': currentScore - pointsRequired,
      });

      final rewardRef = userRef.collection('rewardsHistory').doc();
      transaction.set(rewardRef, {
        'rewardId': rewardId,
        'rewardName': rewardName,
        'pointsUsed': pointsRequired,
        'redeemedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}