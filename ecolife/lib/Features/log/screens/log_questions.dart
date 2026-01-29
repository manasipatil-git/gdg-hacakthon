class LogQuestion {
  final String id;
  final String text;
  final List<LogOption> options;
  final String? icon;
  final bool Function(Map<String, dynamic> answers)? shouldShow;

  LogQuestion({
    required this.id,
    required this.text,
    required this.options,
    this.icon,
    this.shouldShow,
  });
}

class LogOption {
  final String text;
  final dynamic value;
  final String? emoji;

  LogOption({
    required this.text,
    required this.value,
    this.emoji,
  });
}

// All questions in order
final List<LogQuestion> allQuestions = [
  // ======== TRAVEL SECTION ========
  LogQuestion(
    id: 'didTravel',
    text: 'Did you travel today?',
    icon: '🚗',
    options: [
      LogOption(text: 'Yes', value: true, emoji: '✅'),
      LogOption(text: 'No', value: false, emoji: '🏠'),
    ],
  ),
  
  LogQuestion(
    id: 'travelMode',
    text: 'Primary mode of travel',
    icon: '🚌',
    shouldShow: (answers) => answers['didTravel'] == true,
    options: [
      LogOption(text: 'Walk', value: 'Walk', emoji: '🚶'),
      LogOption(text: 'Cycle', value: 'Cycle', emoji: '🚴'),
      LogOption(text: 'Bus', value: 'Bus', emoji: '🚌'),
      LogOption(text: 'Train', value: 'Train', emoji: '🚂'),
      LogOption(text: 'Two-wheeler', value: 'Two-wheeler', emoji: '🛵'),
      LogOption(text: 'Car', value: 'Car', emoji: '🚗'),
    ],
  ),
  
  LogQuestion(
    id: 'distance',
    text: 'Approx. total distance',
    icon: '📏',
    shouldShow: (answers) => answers['didTravel'] == true,
    options: [
      LogOption(text: '< 1 km', value: '< 1 km'),
      LogOption(text: '1 – 5 km', value: '1 – 5 km'),
      LogOption(text: '5 – 10 km', value: '5 – 10 km'),
      LogOption(text: '10 – 20 km', value: '10 – 20 km'),
      LogOption(text: '> 20 km', value: '> 20 km'),
    ],
  ),
  
  LogQuestion(
    id: 'fuelType',
    text: 'Fuel type',
    icon: '⛽',
    shouldShow: (answers) =>
        answers['travelMode'] == 'Two-wheeler' ||
        answers['travelMode'] == 'Car',
    options: [
      LogOption(text: 'Petrol', value: 'Petrol', emoji: '⛽'),
      LogOption(text: 'Diesel', value: 'Diesel', emoji: '🛢️'),
      LogOption(text: 'Electric', value: 'Electric', emoji: '🔋'),
    ],
  ),
  
  LogQuestion(
    id: 'occupancy',
    text: 'How many people shared?',
    icon: '👥',
    shouldShow: (answers) =>
        answers['travelMode'] == 'Two-wheeler' ||
        answers['travelMode'] == 'Car',
    options: [
      LogOption(text: 'Just me', value: 'Just me', emoji: '1️⃣'),
      LogOption(text: '2 people', value: '2 people', emoji: '2️⃣'),
      LogOption(text: '3–4 people', value: '3–4 people', emoji: '3️⃣'),
      LogOption(text: '5+ people', value: '5+ people', emoji: '5️⃣'),
    ],
  ),
  
  // ======== FOOD SECTION ========
  LogQuestion(
    id: 'mealType',
    text: 'What describes your meals?',
    icon: '🍽️',
    options: [
      LogOption(text: 'Fully vegetarian', value: 'Fully vegetarian', emoji: '🥗'),
      LogOption(text: 'Mixed (veg + non-veg)', value: 'Mixed (veg + non-veg)', emoji: '🍛'),
      LogOption(text: 'Mostly non-vegetarian', value: 'Mostly non-vegetarian', emoji: '🍖'),
    ],
  ),
  
  LogQuestion(
    id: 'nonVegMeals',
    text: 'Number of non-veg meals',
    icon: '🍗',
    shouldShow: (answers) => answers['mealType'] != 'Fully vegetarian',
    options: [
      LogOption(text: '1', value: '1', emoji: '1️⃣'),
      LogOption(text: '2', value: '2', emoji: '2️⃣'),
      LogOption(text: '3+', value: '3+', emoji: '3️⃣'),
    ],
  ),
  
  LogQuestion(
    id: 'nonVegType',
    text: 'Type of non-veg consumed',
    icon: '🍖',
    shouldShow: (answers) => answers['mealType'] != 'Fully vegetarian',
    options: [
      LogOption(text: 'Chicken', value: 'Chicken', emoji: '🍗'),
      LogOption(text: 'Fish', value: 'Fish', emoji: '🐟'),
      LogOption(text: 'Mutton / Beef', value: 'Mutton / Beef', emoji: '🥩'),
      LogOption(text: 'Eggs only', value: 'Eggs only', emoji: '🥚'),
    ],
  ),
  
  LogQuestion(
    id: 'packagedFood',
    text: 'Packaged / fast food today',
    icon: '🍟',
    options: [
      LogOption(text: 'None', value: 'None', emoji: '🚫'),
      LogOption(text: '1 item', value: '1 item', emoji: '1️⃣'),
      LogOption(text: '2–3 items', value: '2–3 items', emoji: '2️⃣'),
      LogOption(text: 'More than 3', value: 'More than 3', emoji: '3️⃣'),
    ],
  ),
  
  LogQuestion(
    id: 'foodSource',
    text: 'Source of food',
    icon: '🏠',
    options: [
      LogOption(text: 'Home cooked', value: 'Home cooked', emoji: '🏠'),
      LogOption(text: 'Canteen / Mess', value: 'Canteen / Mess', emoji: '🍱'),
      LogOption(text: 'Restaurant / Online delivery', value: 'Restaurant / Online delivery', emoji: '🛵'),
      LogOption(text: 'Multiple sources', value: 'Multiple sources', emoji: '🔀'),
    ],
  ),
  
  LogQuestion(
    id: 'foodWastage',
    text: 'Food wastage today',
    icon: '🗑️',
    options: [
      LogOption(text: 'None', value: 'None', emoji: '✅'),
      LogOption(text: 'Small amount', value: 'Small amount', emoji: '⚠️'),
      LogOption(text: 'Significant amount', value: 'Significant amount', emoji: '❌'),
    ],
  ),
  
  // ======== WATER & BEVERAGES ========
  LogQuestion(
    id: 'waterSource',
    text: 'Drinking water source',
    icon: '💧',
    options: [
      LogOption(text: 'Personal reusable bottle', value: 'Personal reusable bottle', emoji: '♻️'),
      LogOption(text: 'Refilled from purifier', value: 'Refilled from purifier', emoji: '💧'),
      LogOption(text: 'Bought disposable bottles', value: 'Bought disposable bottles', emoji: '🥤'),
    ],
  ),
  
  LogQuestion(
    id: 'bottleCount',
    text: 'Number of disposable bottles',
    icon: '🥤',
    shouldShow: (answers) => answers['waterSource'] == 'Bought disposable bottles',
    options: [
      LogOption(text: '1', value: '1', emoji: '1️⃣'),
      LogOption(text: '2', value: '2', emoji: '2️⃣'),
      LogOption(text: '3+', value: '3+', emoji: '3️⃣'),
    ],
  ),
  
  LogQuestion(
    id: 'beverages',
    text: 'Beverages consumed',
    icon: '☕',
    options: [
      LogOption(text: 'Homemade', value: 'Homemade', emoji: '🏠'),
      LogOption(text: 'Canteen / Café', value: 'Canteen / Café', emoji: '☕'),
      LogOption(text: 'Bottled drinks', value: 'Bottled drinks', emoji: '🥤'),
      LogOption(text: 'Multiple', value: 'Multiple', emoji: '🔀'),
    ],
  ),
  
  LogQuestion(
    id: 'hotBeverages',
    text: 'Hot beverages (tea / coffee)',
    icon: '☕',
    options: [
      LogOption(text: 'None', value: 'None', emoji: '🚫'),
      LogOption(text: '1 cup', value: '1 cup', emoji: '1️⃣'),
      LogOption(text: '2 cups', value: '2 cups', emoji: '2️⃣'),
      LogOption(text: '3+ cups', value: '3+ cups', emoji: '3️⃣'),
    ],
  ),
  
  LogQuestion(
    id: 'coldDrinks',
    text: 'Cold drinks / sugary beverages',
    icon: '🥤',
    options: [
      LogOption(text: 'None', value: 'None', emoji: '🚫'),
      LogOption(text: '1', value: '1', emoji: '1️⃣'),
      LogOption(text: '2+', value: '2+', emoji: '2️⃣'),
    ],
  ),
];