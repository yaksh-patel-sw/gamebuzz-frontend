import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../screens/game_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Game List'),
      ),
      body: gameProvider.games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gameProvider.games.length,
              itemBuilder: (context, index) {
                final game = gameProvider.games[index];
                return ListTile(
                  title: Text(game.title),
                  subtitle: Text(game.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailScreen(gameId: game.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}