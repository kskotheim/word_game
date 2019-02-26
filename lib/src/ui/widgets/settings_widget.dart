import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:word_game/src/models/difficulty.dart';

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
            _difficultyButton(Difficulty.EASY),
            _difficultyButton(Difficulty.MEDIUM),
            _difficultyButton(Difficulty.HARD),
          ],
        );
      }
    );
  }

  RaisedButton _difficultyButton(Difficulty difficulty){
    return RaisedButton(
      color: Style.BUTTON_COLOR,
      child: Container(
        width: SETTINGS_BUTTON_WIDTH,
        height: SETTINGS_BUTTON_HEIGHT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            playBloc.difficultyName == difficulty.name ? Icon(Icons.check) : Container(),
            Text(difficulty.name, style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
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