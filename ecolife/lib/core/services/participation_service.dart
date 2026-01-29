import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipationService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _collection = 'participations';

  /// ================= CHECK IF USER JOINED =================

  static Future<bool> hasUserParticipated({
    required String userId,
    required String campaignId,
  }) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('campaignId', isEqualTo: campaignId)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Check participation error: $e');
      return false;
    }
  }

  /// ================= JOIN CAMPAIGN =================

  static Future<String?> joinCampaign({
    required String userId,
    required String campaignId,
    required String campaignTitle,
  }) async {
    try {
      // 1. Create participation record
      final docRef = await _firestore
          .collection(_collection)
          .add({
        'userId': userId,
        'campaignId': campaignId,
        'campaignTitle': campaignTitle,
        'joinedAt': Timestamp.now(),
      });

      // 2. Increment participant count in campaign
      await _firestore
          .collection('campaigns')
          .doc(campaignId)
          .update({
        'progress.participantCount':
            FieldValue.increment(1),
        'progress.volunteerCount':
            FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      print('Join campaign error: $e');
      return null;
    }
  }
}
