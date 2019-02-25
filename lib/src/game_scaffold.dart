import 'package:flutter/material.dart';
import 'package:word_game/src/ui/game_screen.dart';

class GameScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GameScreen(),
      ),
    );
  }
}
