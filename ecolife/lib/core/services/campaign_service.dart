import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/campaign.dart';

class CampaignService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'campaigns';

  /// ================= CREATE =================
  static Future<String?> createCampaign(Campaign campaign) async {
    try {
      print('📝 Creating campaign: ${campaign.title}');
      final docRef = await _firestore
          .collection(_collection)
          .add(campaign.toMap());
      print('✅ Campaign created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Create campaign error: $e');
      return null;
    }
  }

  /// ================= STREAMS =================
  static Stream<List<Campaign>> getActiveCampaignsStream() {
    print('🔥 Setting up active campaigns stream...');
    
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('📥 Snapshot received: ${snapshot.docs.length} documents');
          
          for (var doc in snapshot.docs) {
            print('📄 Doc ID: ${doc.id}, Title: ${doc.data()['title']}');
          }
          
          return _mapSnapshotToCampaigns(snapshot);
        })
        .handleError((error) {
          print('❌ Stream Error: $error');
        });
  }

  static Stream<List<Campaign>> getFeaturedCampaignsStream() {
    return _firestore
        .collection(_collection)
        .where('isFeatured', isEqualTo: true)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(_mapSnapshotToCampaigns);
  }

  static Stream<List<Campaign>> getTrendingCampaignsStream() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('progress.participantCount', descending: true)
        .limit(10)
        .snapshots()
        .map(_mapSnapshotToCampaigns);
  }

  /// ================= HELPERS =================
  static List<Campaign> _mapSnapshotToCampaigns(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      try {
        return Campaign.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      } catch (e) {
        print('❌ Error mapping doc ${doc.id}: $e');
        rethrow;
      }
    }).toList();
  }
}