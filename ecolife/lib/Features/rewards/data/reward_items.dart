class RewardItem {
  final String name;
  final int cost;
  final String emoji;
  final String location;

  RewardItem({
    required this.name,
    required this.cost,
    required this.emoji,
    required this.location,
  });
}

final List<RewardItem> rewardItems = [
  RewardItem(name: 'Chai', cost: 30, emoji: '☕', location: 'Tea Stall'),
  RewardItem(name: 'Cookie', cost: 50, emoji: '🍪', location: 'Main Canteen'),
  RewardItem(name: 'Brownie', cost: 90, emoji: '🍫', location: 'Bakery'),
  RewardItem(name: 'Cake Slice', cost: 120, emoji: '🍰', location: 'Bakery'),
  RewardItem(name: 'Fruit Juice', cost: 70, emoji: '🧃', location: 'Juice Counter'),
];
