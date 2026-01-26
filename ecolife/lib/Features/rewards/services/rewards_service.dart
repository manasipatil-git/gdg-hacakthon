import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reward_model.dart';

class RewardsService {
  final _db = FirebaseFirestore.instance;

  Stream<int> userEcoScore(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => doc.data()?['ecoScore'] ?? 0,
        );
  }

  Stream<List<Reward>> getRewards() {
    return _db
        .collection('rewards')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Reward.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> redeemReward({
    required String uid,
    required Reward reward,
  }) async {
    final userRef = _db.collection('users').doc(uid);
    final redemptionRef = _db.collection('redemptions').doc();

    await _db.runTransaction((tx) async {
      final userSnap = await tx.get(userRef);
      final currentScore = userSnap['ecoScore'] ?? 0;

      if (currentScore < reward.ecoScoreCost) {
        throw Exception('Insufficient EcoScore');
      }

      tx.update(userRef, {
        'ecoScore': currentScore - reward.ecoScoreCost,
      });

      tx.set(redemptionRef, {
        'uid': uid,
        'rewardId': reward.id,
        'ecoScoreUsed': reward.ecoScoreCost,
        'timestamp': FieldValue.serverTimestamp(),
        'qrToken': redemptionRef.id,
      });
    });
  }
}
