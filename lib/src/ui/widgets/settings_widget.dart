import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/resources/style.dart';

class SettingsWidget extends StatelessWidget {
  static const double SETTINGS_BUTTON_WIDTH = 100.0;
  static const double SETTINGS_BUTTON_HEIGHT = 80.0;

  PlayBloc playBloc;
  GameBloc gameBloc;

  @override
  Widget build(BuildContext context) {
    playBloc = BlocProvider.of<PlayBloc>(context);
    gameBloc = BlocProvider.of<GameBloc>(context);

    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _difficultyButton(Difficulty.easy, 'Easy'),
            _difficultyButton(Difficulty.medium, 'Medium'),
            _difficultyButton(Difficulty.hard, 'Hard'),
          ],
        );
      }
    );
  }

  RaisedButton _difficultyButton(Difficulty difficulty, String difficultyString){
    return RaisedButton(
      color: Style.BUTTON_COLOR,
      child: Container(
        width: SETTINGS_BUTTON_WIDTH,
        height: SETTINGS_BUTTON_HEIGHT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            playBloc.difficulty == difficulty ? Icon(Icons.check) : Container(),
            Text(difficultyString, style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
            Container()
          ],
        ),
      ),
      onPressed: (){
        playBloc.guessSink.add(SetDifficulty(difficulty: difficulty));
        gameBloc.gameButton.add(GoHomeEvent());
      },
    );
  }
}