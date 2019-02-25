import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class SettingsWidget extends StatelessWidget {
  PlayBloc playBloc;
  GameBloc gameBloc;

  @override
  Widget build(BuildContext context) {
    playBloc = BlocProvider.of<PlayBloc>(context);
    gameBloc =BlocProvider.of<GameBloc>(context);

    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      child: Row(
        children: <Widget>[
          playBloc.difficulty == difficulty ? Icon(Icons.check) : Container(),
          Text(difficultyString),
        ],
      ),
      onPressed: (){
        playBloc.guessSink.add(SetDifficulty(difficulty: difficulty));
        gameBloc.gameButton.add(GoHomeEvent());
      },
    );
  }
}