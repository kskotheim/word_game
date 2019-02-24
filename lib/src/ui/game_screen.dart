import 'package:flutter/material.dart';
import 'package:word_game/src/ui/widgets/problem_widget.dart';
import 'package:word_game/src/resources/style.dart';

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
      screen = Container();
      break;
    default:
      screen = ErrorScreen();
      break;
  }
  return screen;
}

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

class EndGameScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    GameBloc gameBloc = BlocProvider.of<GameBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Game Over!', style: Style.BLACK_TITLE_TEXT_STYLE,),
        Text('${gameBloc.finalScore.toString()} points', style: Style.BLACK_TITLE_TEXT_STYLE,),
        FlatButton(
          child: Text('Go Home', style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
          onPressed: () => gameBloc.gameButton.add(GoHomeEvent()),
        )
      ],
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Error!');
  }
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
