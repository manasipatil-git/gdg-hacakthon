import 'package:cloud_firestore/cloud_firestore.dart';

class RedemptionHistory {
  final String id;
  final String itemId;
  final String itemName;
  final String itemEmoji;
  final int pointsCost;
  final String location;
  final DateTime redeemedAt;
  final bool isUsed;

  RedemptionHistory({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemEmoji,
    required this.pointsCost,
    required this.location,
    required this.redeemedAt,
    this.isUsed = false,
  });

  factory RedemptionHistory.fromFirestore(String id, Map<String, dynamic> data) {
    return RedemptionHistory(
      id: id,
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      itemEmoji: data['itemEmoji'] ?? '🎁',
      pointsCost: data['pointsCost'] ?? 0,
      location: data['location'] ?? '',
      redeemedAt: (data['redeemedAt'] as Timestamp).toDate(),
      isUsed: data['isUsed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemEmoji': itemEmoji,
      'pointsCost': pointsCost,
      'location': location,
      'redeemedAt': Timestamp.fromDate(redeemedAt),
      'isUsed': isUsed,
    };
  }
}