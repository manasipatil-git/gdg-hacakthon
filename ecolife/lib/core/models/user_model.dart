class UserModel {
  final String uid;
  final String name;
  final int ecoScore;
  final int streak;

  UserModel({
    required this.uid,
    required this.name,
    required this.ecoScore,
    required this.streak,
  });

  /// Factory to convert Firestore document → UserModel
  /// Firestore stores streak as currentStreak; accepts both for compatibility.
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      ecoScore: data['ecoScore'] ?? 0,
      streak: ((data['currentStreak'] ?? data['streak'] ?? 0) as num).toInt(),
    );
  }

  /// Convert UserModel → Firestore map (for updates if needed)
  Map<String, dynamic> toMap() {
    return {'name': name, 'ecoScore': ecoScore, 'streak': streak};
  }
}
