import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthService _authService = AuthService();
  String? _token;

  String? get token => _token;

  Future<void> login(String username, String password) async {
    _token = await _authService.login(username, password);
    notifyListeners();
  }

  Future<void> register(String username, String password, String email, String firstName, String lastName, String mobileNumber, String gameSelection, DateTime dateOfBirth, bool termsAccepted) async {
    await _authService.register(username, password, email, firstName, lastName, mobileNumber, gameSelection, dateOfBirth, termsAccepted);
  }

  Future<void> googleLogin() async {
    _token = await _authService.googleLogin();
    notifyListeners();
  }

  // Add Riot Games login method if needed
}