import 'package:cloud_firestore/cloud_firestore.dart';
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
      'ecoScore': 0, // ✅ single source of truth
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

  /// REAL eco action logger (called from Log screen)
  Future<void> logEcoAction({
    required String uid,
    required int points,
  }) async {
    await _db.collection('users').doc(uid).set({
      'ecoScore': FieldValue.increment(points),
    }, SetOptions(merge: true));
  }
}
