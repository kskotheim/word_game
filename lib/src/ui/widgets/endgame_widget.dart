import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:word_game/src/blocs/play_bloc.dart';

class EndGameScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    GameBloc gameBloc = BlocProvider.of<GameBloc>(context);
    HighScoreBloc highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    PlayBloc playBloc = BlocProvider.of<PlayBloc>(context);

    highScoreBloc.highScoreEvent.add(SetHighScore(highScore: gameBloc.finalScore, difficulty: playBloc.difficultyName));

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Game Over!', style: Style.BLACK_TITLE_TEXT_STYLE,),
        Text('${gameBloc.finalScore.toString()} points', style: Style.BLACK_TITLE_TEXT_STYLE,),
        RaisedButton(
          color: Style.BUTTON_COLOR,
          padding: Style.BUTTON_PADDING,
          child: Text('Go Home', style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
          onPressed: () => gameBloc.gameButton.add(GoHomeEvent()),
        )
      ],
    );
  }
}