import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  /// SESSION LOCK (lives for entire app runtime)
  bool hasLoggedEcoActionThisSession = false;

  UserModel? get user => _user;

  /// Set user data (called on login & Firestore refresh)
  /// ❗ DO NOT reset session lock here
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  /// Eco action: allowed ONLY once per app session
  void logEcoActionOncePerSession({int points = 10}) {
    if (_user == null) return;

    if (hasLoggedEcoActionThisSession) return;

    hasLoggedEcoActionThisSession = true;

    _user = UserModel(
      uid: _user!.uid,
      name: _user!.name,
      ecoScore: _user!.ecoScore + points,
      streak: _user!.streak,
    );

    notifyListeners();
  }

  /// Clear everything on logout (new session after login)
  void clear() {
    _user = null;
    hasLoggedEcoActionThisSession = false;
    notifyListeners();
  }
}
