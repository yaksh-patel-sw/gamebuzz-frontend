import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:5000/api/users';

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return data; // Return the entire response data
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, String email, String firstName, String lastName, String mobileNumber, String gameSelection, DateTime dateOfBirth, bool termsAccepted) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'mobile_number': mobileNumber,
        'game_selection': gameSelection,
        'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
        'terms_accepted': termsAccepted,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Return the user object
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> verifyEmail(int userId, String verificationCode) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'verificationCode': verificationCode,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify email');
    }
  }

  Future<Map<String, dynamic>> createTeam(int gameId, String gameMode, String adminName, String adminNumber, String adminEmail, String teamName, int teamMemberCount) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create-team'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'gameId': gameId,
        'gameMode': gameMode,
        'adminName': adminName,
        'adminNumber': adminNumber,
        'adminEmail': adminEmail,
        'teamName': teamName,
        'teamMemberCount': teamMemberCount,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Return the team object
    } else {
      throw Exception('Failed to create team');
    }
  }

  Future<void> addTeamMember(int teamId, String memberName, int memberId, String role) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add-team-member'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'teamId': teamId,
        'memberName': memberName,
        'memberId': memberId,
        'role': role,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add team member');
    }
  }

  Future<void> sendTeamIdEmail(String adminEmail, int teamId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-team-id-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'adminEmail': adminEmail,
        'teamId': teamId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send team ID email');
    }
  }

  Future<Map<String, dynamic>> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return {};

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String idToken = googleAuth.idToken ?? '';

      final response = await http.post(
        Uri.parse('$_baseUrl/login/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return data; // Return the entire response data
      } else {
        throw Exception('Failed to login with Google');
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  // Add Riot Games login method if needed
}