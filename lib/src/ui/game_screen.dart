import 'package:flutter/material.dart';
import 'package:word_game/src/ui/widgets/problem_widget.dart';
import 'package:word_game/src/ui/widgets/endgame_widget.dart';
import 'package:word_game/src/ui/widgets/home_widget.dart';
import 'package:word_game/src/ui/widgets/settings_widget.dart';
import 'package:word_game/src/ui/widgets/highscores_widget.dart';
import 'package:word_game/src/ui/widgets/naming_widget.dart';

import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class GameScreen extends StatelessWidget {
  static final GameBloc _gameBloc = GameBloc();
  static final PlayBloc _playBloc = PlayBloc(gameBloc: _gameBloc);
  static final HighScoreBloc _highScoreBloc = HighScoreBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _gameBloc,
      child: BlocProvider(
        bloc: _playBloc,
        child: BlocProvider(
          bloc: _highScoreBloc,
          child: StreamBuilder(
            stream: _gameBloc.gameStatus,
            builder: (BuildContext context, AsyncSnapshot<GameStatus> status) {
              Widget _gameScreen = _getGameScreen(status.data);
              return WillPopScope(
                  onWillPop: () async {
                    if (status.data == GameStatus.home)
                      return true;
                    else {
                      _gameBloc.gameButton.add(GoHomeEvent());
                      return false;
                    }
                  },
                  child: _gameScreen);
            },
          ),
        ),
      ),
    );
  }
  Widget _getGameScreen(GameStatus status) {
    switch (status) {
      case GameStatus.home:
        return Home();
      case GameStatus.playing:
        return ProblemWidget();
      case GameStatus.ending:
        return EndGameScreen();
      case GameStatus.settings:
        return SettingsWidget();
      case GameStatus.highScores:
        return HighScoresWidget();
      case GameStatus.naming:
        return NamingPage(currentName: _highScoreBloc.currentUserName,);
      default:
        return Text('Error!');
    }
  }
}


