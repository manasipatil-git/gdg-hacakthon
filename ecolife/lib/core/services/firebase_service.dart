import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
