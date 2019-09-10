import 'package:flutter/material.dart';
import 'package:word_game/src/ui/game_screen.dart';
import 'package:word_game/src/resources/style.dart';

class GameScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: Style.HOME_SCAFFOLD_DECORATION,
          child: GameScreen(),
        ),
      ),
    );
  }
}
