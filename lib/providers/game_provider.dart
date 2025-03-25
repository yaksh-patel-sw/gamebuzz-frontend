import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/game.dart';

class GameProvider with ChangeNotifier {
  GameService _gameService = GameService();
  List<Game> _games = [];

  List<Game> get games => _games;

  Future<void> fetchGames() async {
    _games = await _gameService.getGames();
    notifyListeners();
  }

  Future<Game> fetchGameById(String id) async {
    return await _gameService.getGameById(id);
  }
}