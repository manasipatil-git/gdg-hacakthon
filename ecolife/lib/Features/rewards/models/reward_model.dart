class Reward {
  final String id;
  final String name;
  final String location;
  final int ecoScoreCost;

  Reward({
    required this.id,
    required this.name,
    required this.location,
    required this.ecoScoreCost,
  });

  factory Reward.fromMap(String id, Map<String, dynamic> data) {
    return Reward(
      id: id,
      name: data['name'],
      location: data['location'],
      ecoScoreCost: data['ecoScoreCost'],
    );
  }
}
