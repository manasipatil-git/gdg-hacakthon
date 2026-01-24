import '../../core/services/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    await _authService.loginWithEmail(email, password);
  }

  Future<void> signup(String name, String email, String password) async {
    await _authService.signupWithEmail(name, email, password);
  }

  Future<void> googleLogin() async {
    await _authService.loginWithGoogle();
  }
}
