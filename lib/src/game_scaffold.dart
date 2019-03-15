import 'package:flutter/material.dart';
import 'package:word_game/src/ui/game_screen.dart';

class GameScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BoxDecoration backgroundDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.1, 0.2, 0.8, 0.9],
        colors: [
          Colors.indigo[50],
          Colors.indigo[100],
          Colors.indigo[200],
          Colors.indigo[300],
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: backgroundDecoration,
          child: GameScreen(),
        ),
      ),
    );
  }
}
