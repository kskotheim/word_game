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

  var _curvedBorderBoxDecoration = BoxDecoration(border: Border.all(color: Colors.black45), borderRadius: BorderRadius.all(Radius.circular(20.0)));


  @override
  Widget build(BuildContext context) {
    _highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    _gameBloc = BlocProvider.of<GameBloc>(context);

    return StreamBuilder<Object>(
        stream: _highScoreBloc.highScores,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Center(child: Text('loading'));
          double height = MediaQuery.of(context).size.height;
          List<HighScore> theScores = snapshot.data;
          return Column(
            children: <Widget>[
              _highscoresTitle(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _recentHighScoresBtn(),
                  _allTimeHighScoresBtn(),
                ],
              ),
              _highscoresListview(height, theScores),
              _goHomeButton()
            ],
          );
        });
  }

  Widget _recentHighScoresBtn() {
    return Container(
      decoration: _highScoreBloc.recent ? _curvedBorderBoxDecoration : null,
      child: FlatButton(
        child: Text('Recent'),
        onPressed: () {
          _highScoreBloc.highScoreEvent.add(GetRecentHighScores());
        },
      ),
    );
  }

  Widget _allTimeHighScoresBtn() {
        return Container(
          decoration: _highScoreBloc.recent ? null : _curvedBorderBoxDecoration,
      child: FlatButton(
        child: Text('All Time'),
        onPressed: () {
          _highScoreBloc.highScoreEvent.add(GetAllHighScores());
        },
      ),
    );
  }

  Container _highscoresListview(double height, List<HighScore> theScores) {
    return Container(
      padding: Style.LISTVIEW_PADDING,
      height: height - 240.0,
      child: Scrollbar(
        child: ListView(
          shrinkWrap: true,
          children: theScores
              .map((scoreObj) => ListTile(
                    dense: true,
                    title: Text('${scoreObj.name} - ${scoreObj.score}'),
                    subtitle: Text(_fromDateTime(scoreObj.time)),
                    leading: _letterIcon(scoreObj.difficulty),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Padding _highscoresTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40.0, 0, 30.0),
      child: Text(
        'High Scores',
        style: Style.BLACK_TITLE_TEXT_STYLE,
      ),
    );
  }

  RaisedButton _goHomeButton() {
    return RaisedButton(
      color: Style.BUTTON_COLOR,
      padding: Style.BUTTON_PADDING,
      child: Text('Home', style: Style.BLACK_SUBTITLE_TEXT_STYLE),
      onPressed: () => _gameBloc.gameButton.add(GoHomeEvent()),
    );
  }

  Widget _letterIcon(String difficulty) {
    if (difficulty == Difficulty.EASY_STRING)
      return Text('E', style: Style.BLACK_TITLE_TEXT_STYLE);
    if (difficulty == Difficulty.MEDIUM_STRING)
      return Text('M', style: Style.BLACK_TITLE_TEXT_STYLE);
    if (difficulty == Difficulty.HARD_STRING)
      return Text('H', style: Style.BLACK_TITLE_TEXT_STYLE);
    if (difficulty == Difficulty.SUDDEN_DEATH_STRING)
      return Text('3L', style: Style.BLACK_TITLE_TEXT_STYLE);
    return Container();
  }

  String _fromDateTime(DateTime time) {
    return DateFormat("EEE, MMM d, ''yy").format(time);
  }
}
