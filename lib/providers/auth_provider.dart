import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;

  String? get token => _token;

  Future<void> login(String username, String password) async {
    _token = await _authService.login(User(username: username, password: password));
    notifyListeners();
  }

  Future<void> register(String username, String password) async {
    await _authService.register(User(username: username, password: password));
  }
}