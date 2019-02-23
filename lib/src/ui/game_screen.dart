import 'package:flutter/material.dart';
import '../resources/style.dart';
import '../blocs/game_bloc.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/ui/widgets/problem_widget.dart';


class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO: stream _status from game bloc
    GameBloc _gameBloc = GameBloc();
    PlayBloc _playBloc = PlayBloc(gameBloc: _gameBloc);



    return StreamBuilder(
      stream: _gameBloc.gameStatus,
      builder: (BuildContext context, AsyncSnapshot<GameStatus> status){
        Widget _gameScreen;

        switch (status.data) {
          case GameStatus.home:
            _gameScreen = Home(gameBloc: _gameBloc,);
            break;
          case GameStatus.playing:
            _gameScreen = ProblemWidget(playBloc: _playBloc);
            break;
          case GameStatus.ending:
            _gameScreen = Container();
            break;
          case GameStatus.settings:
            _gameScreen = Container();
            break;
          default:
            _gameScreen = ErrorScreen();
            break;
        }
        return _gameScreen;
      },
    );
  }
}


class Home extends StatelessWidget {
  final GameBloc gameBloc;

  Home({this.gameBloc});
  
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GameButton(whenPressed: playPressed, title: 'Play'),
        GameButton(whenPressed: settingsPressed, title: 'Settings'),
        
      ],
    );
  }

  void settingsPressed() => print('settings pressed');
  void playPressed() => gameBloc.gameButton.add(PlayGameEvent());

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

  GameButton({this.whenPressed, this.title}) : assert(whenPressed != null, title != null);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: whenPressed,
      child: Text(title, style: Style.BLACK_SUBTITLE_TEXT_STYLE),
    );
  }
}

