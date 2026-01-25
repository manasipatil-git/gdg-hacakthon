import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firestore_service.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  /// ─────────────────────────────
  /// SIGN UP USER
  /// ─────────────────────────────
  Future<void> signup(
    String name,
    String email,
    String password,
  ) async {
    // 1️⃣ Create user in Firebase Auth
    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String uid = credential.user!.uid;

    // 2️⃣ Create Firestore user document
    await _firestore.createUser(
      uid: uid,
      name: name,
      email: email,
    );
  }

  /// ─────────────────────────────
  /// LOGIN USER (decides next route)
  /// ─────────────────────────────
  Future<String> login(
    String email,
    String password,
  ) async {
    // 1️⃣ Login with Firebase Auth
    final UserCredential credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String uid = credential.user!.uid;

    // 2️⃣ Check onboarding status
    final bool completed =
        await _firestore.isOnboardingCompleted(uid);

    // 3️⃣ Tell UI where to go
    return completed ? '/dashboard' : '/onboarding';
  }

  /// ─────────────────────────────
  /// LOGOUT USER
  /// ─────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
  }
}