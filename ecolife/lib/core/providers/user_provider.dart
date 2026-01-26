import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // 🔒 DEMO SESSION FLAG
  // Ensures eco action can be logged only once per app session
  bool demoActionLoggedThisSession = false;

  /// Set user after login / onboarding
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Mark demo eco action as logged (SESSION ONLY)
  void markDemoActionLogged() {
    demoActionLoggedThisSession = true;
    notifyListeners();
  }

  /// Update eco score locally (still useful)
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

  /// Clear everything on logout
  void clear() {
    _user = null;
    demoActionLoggedThisSession = false;
    notifyListeners();
  }
}
