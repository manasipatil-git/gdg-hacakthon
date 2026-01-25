import 'package:cloud_firestore/cloud_firestore.dart';

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
      'totalPoints': 0,
      'avgScore': 0,
      'currentStreak': 0,
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

  /// Fetch user name for dashboard greeting
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

  /// Add a test trip (HACKATHON HAPPY PATH)
  Future<void> addTestTrip(String uid) async {
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

    // 2️⃣ Add trip to trips array
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

    // 3️⃣ Recalculate emissions & score
    final snapshot = await dailyLogRef.get();
    final totalEmissions = snapshot.data()?['totalDayEmissions'] ?? 0;

    final num dailyScore =
        (100 - (totalEmissions * 10)).clamp(0, 100);

    // 4️⃣ Calculate points
    int points = 0;
    if (dailyScore >= 85) {
      points = 10;
    } else if (dailyScore >= 70) {
      points = 5;
    }

    // 5️⃣ Update daily score + points
    await dailyLogRef.update({
      'dailyScore': dailyScore,
      'pointsEarned': points,
    });

    // 6️⃣ Update user total points
    await _db.collection('users').doc(uid).update({
      'totalPoints': FieldValue.increment(points),
    });
  }
}