import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/resources/style.dart';

class Home extends StatelessWidget {
  GameBloc _gameBloc;

  @override
  Widget build(BuildContext context) {
    _gameBloc = BlocProvider.of<GameBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GameButton(whenPressed: playPressed, title: 'Play'),
        GameButton(whenPressed: settingsPressed, title: 'Settings'),
      ],
    );
  }

  void settingsPressed() => print('settings pressed');
  void playPressed() => _gameBloc.gameButton.add(PlayGameEvent());
}

class GameButton extends StatelessWidget {
  final VoidCallback whenPressed;
  final String title;

  GameButton({this.whenPressed, this.title})
      : assert(whenPressed != null, title != null);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: whenPressed,
      child: Text(title, style: Style.BLACK_SUBTITLE_TEXT_STYLE),
    );
  }
}
