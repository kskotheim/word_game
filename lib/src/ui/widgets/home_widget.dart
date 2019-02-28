import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/resources/style.dart';




class Home extends StatelessWidget {

  static const String TITLE_STRING_1 = 'The Word';
  static const String TITLE_STRING_2 = 'More Common';

  GameBloc _gameBloc;
  PlayBloc _playBloc;
  HighScoreBloc _highScoreBloc;

  @override
  Widget build(BuildContext context) {
    _gameBloc = BlocProvider.of<GameBloc>(context);
    _playBloc = BlocProvider.of<PlayBloc>(context);
    _highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    String difficulty = _playBloc.difficultyName;

    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(TITLE_STRING_1, style: Style.BLACK_TITLE_TEXT_STYLE,),
              Text(TITLE_STRING_2, style: Style.BLACK_TITLE_TEXT_STYLE,),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GameButton(whenPressed: playPressed, title: 'Play'),
              GameButton(whenPressed: settingsPressed, title: 'Difficulty: $difficulty'),
              GameButton(whenPressed: highScoresPressed, title: 'High Scores'),
              GameButton(whenPressed: nameButtonPressed, title:'Name: ${_highScoreBloc.currentUserName}',)
            ],
          ),
        ),
        
      ],
    );
  }

  void settingsPressed() => _gameBloc.gameButton.add(SettingsEvent());
  void playPressed() => _gameBloc.gameButton.add(PlayGameEvent());
  void highScoresPressed() { 
    _gameBloc.gameButton.add(HighScoresEvent());
    _highScoreBloc.highScoreEvent.add(GetRecentHighScores());
  }
  void nameButtonPressed(){
    _gameBloc.gameButton.add(NameButtonEvent());
  }
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
