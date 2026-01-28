import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reward_model.dart';

class RewardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user's current eco score
  Future<int> getUserScore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['ecoScore'] ?? 0;
  }

  /// Redeem a reward (deduct points and log redemption)
  Future<void> redeemReward({
    required String uid,
    required String itemId,
    required String itemName,
    required String itemEmoji,
    required int cost,
    required String location,
  }) async {
    // Get current score
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final currentScore = userDoc.data()?['ecoScore'] ?? 0;

    if (currentScore < cost) {
      throw Exception('Insufficient points');
    }

    final newScore = currentScore - cost;

    // Create redemption record
    final redemption = RedemptionHistory(
      id: '', // Will be set by Firestore
      itemId: itemId,
      itemName: itemName,
      itemEmoji: itemEmoji,
      pointsCost: cost,
      location: location,
      redeemedAt: DateTime.now(),
      isUsed: false,
    );

    // Use batch write for atomic operation
    final batch = _firestore.batch();

    // Update user score
    batch.update(
      _firestore.collection('users').doc(uid),
      {'ecoScore': newScore},
    );

    // Add redemption history
    final redemptionRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('redemptions')
        .doc();
    batch.set(redemptionRef, redemption.toMap());

    await batch.commit();
  }

  /// Get user's redemption history
  Stream<List<RedemptionHistory>> getRedemptionHistory(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('redemptions')
        .orderBy('redeemedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RedemptionHistory.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  /// Mark a redemption as used
  Future<void> markAsUsed(String uid, String redemptionId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('redemptions')
        .doc(redemptionId)
        .update({'isUsed': true});
  }

  /// Get total points spent
  Future<int> getTotalPointsSpent(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('redemptions')
        .get();

    int total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['pointsCost'] as int? ?? 0);
    }
    return total;
  }
}