import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  final String _baseUrl = 'http://localhost:5000/api/games';

  Future<List<Game>> getGames() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((game) => Game.fromJson(game)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<Game> getGameById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return Game.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load game');
    }
  }
}