import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/resources/style.dart';

class Home extends StatelessWidget {

  static const String TITLE_STRING_1 = 'The Word';
  static const String TITLE_STRING_2 = 'More Common';

  GameBloc _gameBloc;
  PlayBloc _playBloc;

  @override
  Widget build(BuildContext context) {
    _gameBloc = BlocProvider.of<GameBloc>(context);
    _playBloc = BlocProvider.of<PlayBloc>(context);
    String difficulty = _playBloc.difficultyString();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(TITLE_STRING_1, style: Style.BLACK_TITLE_TEXT_STYLE,),
        Text(TITLE_STRING_2, style: Style.BLACK_TITLE_TEXT_STYLE,),

        GameButton(whenPressed: playPressed, title: 'Play'),
        GameButton(whenPressed: settingsPressed, title: 'Difficulty: $difficulty'),
      ],
    );
  }

  void settingsPressed() => _gameBloc.gameButton.add(SettingsEvent());
  void playPressed() => _gameBloc.gameButton.add(PlayGameEvent());
}

class GameButton extends StatelessWidget {
  final VoidCallback whenPressed;
  final String title;

  GameButton({this.whenPressed, this.title})
      : assert(whenPressed != null, title != null);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: whenPressed,
      color: Style.BUTTON_COLOR,
      child: Container(
        padding: Style.BUTTON_PADDING,
        child: Text(title, style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
      ),
    );
  }
}
