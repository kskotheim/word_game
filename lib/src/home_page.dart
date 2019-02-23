import 'package:flutter/material.dart';
import 'package:word_game/src/ui/game_screen.dart';

class HomePage extends StatelessWidget {
  final String title;
  HomePage({this.title}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: GameScreen(),
      ),
    );
  }
}
