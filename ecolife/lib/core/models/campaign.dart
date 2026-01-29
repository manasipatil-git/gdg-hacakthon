import 'package:cloud_firestore/cloud_firestore.dart';

/// ================= ENUMS =================

enum CampaignType { treePlantation, cleanliness, donation }

extension CampaignTypeX on CampaignType {
  String get displayName {
    switch (this) {
      case CampaignType.treePlantation:
        return 'Tree Plantation';
      case CampaignType.cleanliness:
        return 'Cleanliness Drive';
      case CampaignType.donation:
        return 'Donation';
    }
  }
}

enum GoalType { trees, volunteers, funds }

extension GoalTypeX on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.trees:
        return 'Trees';
      case GoalType.volunteers:
        return 'Volunteers';
      case GoalType.funds:
        return 'Funds';
    }
  }

  String get unit {
    switch (this) {
      case GoalType.trees:
        return 'trees';
      case GoalType.volunteers:
        return 'people';
      case GoalType.funds:
        return '₹';
    }
  }
}

/// ================= SUB MODELS =================

class CampaignGoal {
  final double target;
  final double current;
  final GoalType type;

  CampaignGoal({
    required this.target,
    required this.current,
    required this.type,
  });

  double get progressPercentage =>
      target == 0 ? 0 : (current / target) * 100;

  String get unit => type.unit;

  Map<String, dynamic> toMap() => {
        'target': target,
        'current': current,
        'type': type.name,
      };

  factory CampaignGoal.fromMap(Map<String, dynamic> map) {
    return CampaignGoal(
      target: (map['target'] ?? 0).toDouble(),
      current: (map['current'] ?? 0).toDouble(),
      type: GoalType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
    );
  }
}

class CampaignProgress {
  final int participantCount;
  final int volunteerCount;
  final double totalDonations;

  CampaignProgress({
    required this.participantCount,
    required this.volunteerCount,
    required this.totalDonations,
  });

  Map<String, dynamic> toMap() => {
        'participantCount': participantCount,
        'volunteerCount': volunteerCount,
        'totalDonations': totalDonations,
      };

  factory CampaignProgress.fromMap(Map<String, dynamic> map) {
    return CampaignProgress(
      participantCount: map['participantCount'] ?? 0,
      volunteerCount: map['volunteerCount'] ?? 0,
      totalDonations: (map['totalDonations'] ?? 0).toDouble(),
    );
  }
}

/// ================= MAIN MODEL =================

class Campaign {
  final String id;
  final String title;
  final String description;
  final String organizationName;
  final String imageUrl;
  final CampaignType type;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final CampaignGoal goal;
  final CampaignProgress progress;
  final bool isFeatured;
  final bool isActive;
  final DateTime createdAt;
  final List<String> impactMetrics;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationName,
    required this.imageUrl,
    required this.type,
    this.location,
    required this.startDate,
    required this.endDate,
    required this.goal,
    required this.progress,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    this.impactMetrics = const [],
  });

  bool get acceptsDonations => goal.type == GoalType.funds;

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'organizationName': organizationName,
        'imageUrl': imageUrl,
        'type': type.name,
        'location': location,
        'startDate': startDate,
        'endDate': endDate,
        'goal': goal.toMap(),
        'progress': progress.toMap(),
        'isFeatured': isFeatured,
        'isActive': isActive,
        'createdAt': createdAt,
        'impactMetrics': impactMetrics,
      };

  factory Campaign.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    return Campaign(
      id: id,
      title: map['title'],
      description: map['description'],
      organizationName: map['organizationName'],
      imageUrl: map['imageUrl'],
      type: CampaignType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
      location: map['location'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      goal: CampaignGoal.fromMap(map['goal']),
      progress: CampaignProgress.fromMap(map['progress']),
      isFeatured: map['isFeatured'] ?? false,
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      impactMetrics:
          List<String>.from(map['impactMetrics'] ?? []),
    );
  }
}
