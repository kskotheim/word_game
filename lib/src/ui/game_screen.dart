import 'package:flutter/material.dart';
import 'package:word_game/src/ui/widgets/problem_widget.dart';
import 'package:word_game/src/ui/widgets/endgame_widget.dart';
import 'package:word_game/src/ui/widgets/home_widget.dart';
import 'package:word_game/src/ui/widgets/settings_widget.dart';

import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class GameScreen extends StatelessWidget {

  static final GameBloc _gameBloc = GameBloc();
  static final PlayBloc _playBloc = PlayBloc(gameBloc: _gameBloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _gameBloc,
      child: BlocProvider(
        bloc: _playBloc,
        child: StreamBuilder(
          stream: _gameBloc.gameStatus,
          builder: (BuildContext context, AsyncSnapshot<GameStatus> status) {
            Widget _gameScreen = _getGameScreen(status.data);
            return _gameScreen;
          },
        ),
      ),
    );
  }
}

Widget _getGameScreen(GameStatus status) {
  Widget screen;
  switch (status) {
    case GameStatus.home:
      screen = Home();
      break;
    case GameStatus.playing:
      screen = ProblemWidget();
      break;
    case GameStatus.ending:
      screen = EndGameScreen();
      break;
    case GameStatus.settings:
      screen = SettingsWidget();
      break;
    default:
      screen = ErrorScreen();
      break;
  }
  return screen;
}


class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Error!');
  }
}