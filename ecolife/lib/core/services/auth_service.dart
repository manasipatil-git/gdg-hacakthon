import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginWithEmail(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> signupWithEmail(
    String name,
    String email,
    String password,
  ) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await res.user?.updateDisplayName(name);
    return res.user;
  }

  Future<void> loginWithGoogle() async {
    // Hackathon scope: stub
    // Plug GoogleSignIn here later
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
