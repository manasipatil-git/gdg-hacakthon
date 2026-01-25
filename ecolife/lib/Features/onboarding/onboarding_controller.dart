import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecolife/core/services/firestore_service.dart';

class OnboardingController {
  final FirestoreService _firestore = FirestoreService();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  final Map<String, dynamic> data = {};

  void setCollege(String college) {
    data['college'] = college;
  }

  void setAccommodation(String accommodation) {
    data['accommodation'] = accommodation;
  }

  void setFood(String food) {
    data['foodPreference'] = food;
  }
  void setTransport(String transport) {
    data['preferredTransport'] = transport;
  }

  void setNotifications(bool enabled) {
    data['notificationsEnabled'] = enabled;
  }

  Future<void> finish() async {
    await _firestore.completeOnboarding(_uid, data);
  }
}