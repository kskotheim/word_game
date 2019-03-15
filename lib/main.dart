import 'package:flutter/material.dart';
import 'package:word_game/src/game_scaffold.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Style.APP_TITLE,
      theme: Style.buildThemeData(),
      home: GameScaffold(),
      routes: {
        "/privacy": (_) => new WebviewScaffold(
          url: "https://flutterdeveloper.wordpress.com/word-game-privacy-policy/",
          appBar: new AppBar(
            title: new Text("Privacy Policy"),
          ),
        ),
      },
    );
  }
}


