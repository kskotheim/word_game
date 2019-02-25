import 'package:flutter/material.dart';
import 'package:word_game/src/game_scaffold.dart';
import 'package:word_game/src/resources/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Style.APP_TITLE,
      theme: Style.buildThemeData(),
      home: GameScaffold(),
    );
  }
}


