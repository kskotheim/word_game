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
    TextStyle titleStyle = Style.getRandomTitleStyle();
    return Stack(
      alignment: Alignment.center,
          children: [
            Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(TITLE_STRING_1, style: titleStyle,),
                  Text(TITLE_STRING_2, style: titleStyle,),

                  // StreamBuilder<String>(
                  //   stream: _gameBloc.debugErrorString,
                  //   builder: (context, snapshot){
                  //     if(!snapshot.hasData) return Container();
                  //     return Text('Debug message - ' + snapshot.data);
                  //   },
                  // )

                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Style.button(playPressed, 'Play'),
                  Style.button(settingsPressed, 'Difficulty: $difficulty'),
                  Style.button(highScoresPressed, 'High Scores'),
                  Style.button(nameButtonPressed, 'Name: ${_highScoreBloc.currentUserName}',)
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: StreamBuilder<bool>(
            stream: _gameBloc.soundStatus,
            builder: (context, snapshot){
              if(!snapshot.hasData) return Container();
              if(snapshot.data == true) return IconButton(icon: Icon(Icons.volume_up),onPressed: () => _gameBloc.soundButton.add(false),);
              else return IconButton(icon: Icon(Icons.volume_off), onPressed: () => _gameBloc.soundButton.add(true),);
            },
          ),
        )
      ]
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
