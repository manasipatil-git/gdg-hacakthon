import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  /// Set user after login / onboarding
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Update eco score locally
  void updateEcoScore(int delta) {
    if (_user == null) return;

    _user = UserModel(
      uid: _user!.uid,
      name: _user!.name,
      ecoScore: _user!.ecoScore + delta,
      streak: _user!.streak,
    );

    notifyListeners();
  }

  /// Clear on logout (optional)
  void clear() {
    _user = null;
    notifyListeners();
  }
}