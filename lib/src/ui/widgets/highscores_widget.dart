import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

import 'package:word_game/src/models/high_score.dart';
import 'package:word_game/src/models/difficulty.dart';
import 'package:word_game/src/resources/style.dart';

import 'package:intl/intl.dart';

class HighScoresWidget extends StatelessWidget {
  HighScoreBloc _highScoreBloc;
  GameBloc _gameBloc;

  @override
  Widget build(BuildContext context) {
    _highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    _gameBloc = BlocProvider.of<GameBloc>(context);

    return StreamBuilder<Object>(
        stream: _highScoreBloc.highScores,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Center(child: Text('loading'));

          List<HighScore> theScores = snapshot.data;
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 40.0),
                child: Text('High Scores', style: Style.BLACK_TITLE_TEXT_STYLE,),
              ),
              Container(
                padding: Style.LISTVIEW_PADDING,
                height:300.0,
                child: ListView(
                  children: theScores
                      .map((scoreObj) => ListTile(dense: true, title: Text('${scoreObj.name} - ${scoreObj.score}'), subtitle: Text(_fromDateTime(scoreObj.time)), leading: _letterIcon(scoreObj.difficulty),))
                      .toList(),
                ),
              ),
              RaisedButton(
                color: Style.BUTTON_COLOR,
                padding: Style.BUTTON_PADDING,
                child: Text('Home', style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
                onPressed: () => _gameBloc.gameButton.add(GoHomeEvent()),
              )
            ],
          );
        });
  }

  Widget _letterIcon(String difficulty){
    if(difficulty == Difficulty.EASY_STRING) return Text('E', style: Style.BLACK_TITLE_TEXT_STYLE,);
    if(difficulty == Difficulty.MEDIUM_STRING) return Text('M', style: Style.BLACK_TITLE_TEXT_STYLE,);
    if(difficulty == Difficulty.HARD_STRING) return Text('H', style: Style.BLACK_TITLE_TEXT_STYLE,);
  }

  String _fromDateTime(DateTime time){
    return DateFormat("EEE, MMM d, ''yy").format(time);
  }
}
