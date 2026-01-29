import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogController {
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  // Answers storage
  final Map<String, dynamic> answers = {};
  
  // Calculated values
  double totalEmissions = 0.0; // kg CO₂
  int ecoScore = 0;

  // Answer a question
  void addAnswer(String key, dynamic value) {
    answers[key] = value;
    _calculateEmissions();
  }

  // Calculate total emissions and eco score
  void _calculateEmissions() {
    double travelEmissions = _calculateTravelEmissions();
    double foodEmissions = _calculateFoodEmissions();
    double waterEmissions = _calculateWaterEmissions();
    
    totalEmissions = travelEmissions + foodEmissions + waterEmissions;
    
    // EcoScore = 100 - (Total × 20), minimum 0
    ecoScore = (100 - (totalEmissions * 20)).clamp(0, 100).toInt();
  }

  double _calculateTravelEmissions() {
    if (answers['didTravel'] != true) return 0.0;
    
    String? mode = answers['travelMode'];
    String? distance = answers['distance'];
    
    // Base emissions per km by mode
    Map<String, double> modeEmissions = {
      'Walk': 0.0,
      'Cycle': 0.0,
      'Bus': 0.05,
      'Train': 0.04,
      'Two-wheeler': 0.08,
      'Car': 0.12,
    };
    
    // Distance multipliers
    Map<String, double> distanceKm = {
      '< 1 km': 0.5,
      '1 – 5 km': 3.0,
      '5 – 10 km': 7.5,
      '10 – 20 km': 15.0,
      '> 20 km': 30.0,
    };
    
    double baseEmission = modeEmissions[mode] ?? 0.0;
    double distValue = distanceKm[distance] ?? 0.0;
    double emission = baseEmission * distValue;
    
    // Fuel type adjustment (for motorized)
    if (mode == 'Two-wheeler' || mode == 'Car') {
      String? fuel = answers['fuelType'];
      if (fuel == 'Electric') emission *= 0.3;
      else if (fuel == 'Diesel') emission *= 1.1;
      
      // Occupancy adjustment
      String? occupancy = answers['occupancy'];
      if (occupancy == '2 people') emission *= 0.6;
      else if (occupancy == '3–4 people') emission *= 0.4;
      else if (occupancy == '5+ people') emission *= 0.3;
    }
    
    return emission;
  }

  double _calculateFoodEmissions() {
    String? mealType = answers['mealType'];
    
    Map<String, double> mealEmissions = {
      'Fully vegetarian': 0.2,
      'Mixed (veg + non-veg)': 0.5,
      'Mostly non-vegetarian': 0.8,
    };
    
    double emission = mealEmissions[mealType] ?? 0.0;
    
    // Non-veg meals multiplier
    String? nonVegMeals = answers['nonVegMeals'];
    if (nonVegMeals == '2') emission *= 1.3;
    else if (nonVegMeals == '3+') emission *= 1.6;
    
    // Non-veg type multiplier
    String? nonVegType = answers['nonVegType'];
    if (nonVegType == 'Mutton / Beef') emission *= 1.5;
    else if (nonVegType == 'Fish') emission *= 1.1;
    
    // Packaged food
    String? packaged = answers['packagedFood'];
    if (packaged == '1 item') emission += 0.1;
    else if (packaged == '2–3 items') emission += 0.2;
    else if (packaged == 'More than 3') emission += 0.3;
    
    // Food source
    String? source = answers['foodSource'];
    if (source == 'Restaurant / Online delivery') emission += 0.15;
    
    // Food wastage penalty
    String? wastage = answers['foodWastage'];
    if (wastage == 'Small amount') emission += 0.1;
    else if (wastage == 'Significant amount') emission += 0.3;
    
    return emission;
  }

  double _calculateWaterEmissions() {
    double emission = 0.0;
    
    // Disposable bottles
    String? waterSource = answers['waterSource'];
    if (waterSource == 'Bought disposable bottles') {
      String? bottleCount = answers['bottleCount'];
      if (bottleCount == '1') emission += 0.05;
      else if (bottleCount == '2') emission += 0.1;
      else if (bottleCount == '3+') emission += 0.15;
    }
    
    // Beverages
    String? beverages = answers['beverages'];
    if (beverages == 'Bottled drinks') emission += 0.1;
    
    // Cold drinks
    String? coldDrinks = answers['coldDrinks'];
    if (coldDrinks == '1') emission += 0.05;
    else if (coldDrinks == '2+') emission += 0.1;
    
    return emission;
  }

  // Submit log to Firestore
  Future<void> submit() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    
    await _db.collection('daily_logs').doc('${_uid}_$today').set({
      'uid': _uid,
      'date': today,
      'timestamp': FieldValue.serverTimestamp(),
      ...answers,
      'totalEmissions': totalEmissions,
      'scoreAdded': ecoScore,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('users').doc(_uid).update({
      'ecoScore': FieldValue.increment(ecoScore),
    });
  }

  // Same as Yesterday feature
  Future<void> logSameAsYesterday() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayDate = yesterday.toIso8601String().split('T').first;
    
    try {
      final doc = await _db.collection('daily_logs').doc('${_uid}_$yesterdayDate').get();
      
      if (doc.exists) {
        // Copy yesterday's answers
        final data = doc.data()!;
        answers.clear();
        
        // Copy all answer fields (exclude metadata)
        data.forEach((key, value) {
          if (!['uid', 'date', 'timestamp', 'totalEmissions', 'scoreAdded', 'createdAt'].contains(key)) {
            answers[key] = value;
          }
        });
        
        _calculateEmissions();
      } else {
        // Use default eco-friendly values
        addAnswer('didTravel', false);
        addAnswer('mealType', 'Fully vegetarian');
        addAnswer('waterSource', 'Personal reusable bottle');
      }
      
      await submit();
    } catch (e) {
      // Fallback to defaults
      addAnswer('didTravel', false);
      addAnswer('mealType', 'Fully vegetarian');
      addAnswer('waterSource', 'Personal reusable bottle');
      await submit();
    }
  }

  // Reset controller
  void reset() {
    answers.clear();
    totalEmissions = 0.0;
    ecoScore = 0;
  }
}