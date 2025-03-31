import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthService _authService = AuthService();
  String? _token;
  int? _userId;
  int? _teamId;

  String? get token => _token;
  int? get userId => _userId;
  int? get teamId => _teamId;

  Future<void> login(String username, String password) async {
    try {
      final data = await _authService.login(username, password);
      _token = data['token'];
      _userId = data['id'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(String username, String password, String email, String firstName, String lastName, String mobileNumber, String gameSelection, DateTime dateOfBirth, bool termsAccepted) async {
    try {
      final user = await _authService.register(username, password, email, firstName, lastName, mobileNumber, gameSelection, dateOfBirth, termsAccepted);
      _userId = user['id']; // Extract the user ID from the user object
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifyEmail(String verificationCode) async {
    if (_userId != null) {
      try {
        await _authService.verifyEmail(_userId!, verificationCode);
        _token = null; // Reset token after verification
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> createTeam(int gameId, String gameMode, String adminName, String adminNumber, String adminEmail, String teamName, int teamMemberCount) async {
    try {
      final team = await _authService.createTeam(gameId, gameMode, adminName, adminNumber, adminEmail, teamName, teamMemberCount);
      _teamId = team['id']; // Extract the team ID from the team object
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTeamMember(String memberName, int memberId, String role) async {
    if (_teamId != null) {
      try {
        await _authService.addTeamMember(_teamId!, memberName, memberId, role);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> sendTeamIdEmail(String adminEmail) async {
    if (_teamId != null) {
      try {
        await _authService.sendTeamIdEmail(adminEmail, _teamId!);
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> googleLogin() async {
    try {
      final data = await _authService.googleLogin();
      _token = data['token'];
      _userId = data['id'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Add Riot Games login method if needed
}