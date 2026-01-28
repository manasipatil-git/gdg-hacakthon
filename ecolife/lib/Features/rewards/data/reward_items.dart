class RewardItem {
  final String id;
  final String name;
  final int cost;
  final String emoji;
  final String location;
  final String category;

  RewardItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.emoji,
    required this.location,
    required this.category,
  });
}

final List<RewardItem> rewardItems = [
  RewardItem(
    id: 'chai_001',
    name: 'Chai',
    cost: 30,
    emoji: '☕',
    location: 'Tea Stall',
    category: 'Beverages',
  ),
  RewardItem(
    id: 'cookie_001',
    name: 'Cookie',
    cost: 50,
    emoji: '🍪',
    location: 'Main Canteen',
    category: 'Snacks',
  ),
  RewardItem(
    id: 'brownie_001',
    name: 'Brownie',
    cost: 90,
    emoji: '🍫',
    location: 'Bakery',
    category: 'Desserts',
  ),
  RewardItem(
    id: 'cake_001',
    name: 'Cake Slice',
    cost: 120,
    emoji: '🍰',
    location: 'Bakery',
    category: 'Desserts',
  ),
  RewardItem(
    id: 'juice_001',
    name: 'Fruit Juice',
    cost: 70,
    emoji: '🧃',
    location: 'Juice Counter',
    category: 'Beverages',
  ),
  RewardItem(
    id: 'samosa_001',
    name: 'Samosa',
    cost: 40,
    emoji: '🥟',
    location: 'Main Canteen',
    category: 'Snacks',
  ),
  RewardItem(
    id: 'sandwich_001',
    name: 'Sandwich',
    cost: 80,
    emoji: '🥪',
    location: 'Main Canteen',
    category: 'Food',
  ),
  RewardItem(
    id: 'icecream_001',
    name: 'Ice Cream',
    cost: 60,
    emoji: '🍦',
    location: 'Cafeteria',
    category: 'Desserts',
  ),
];