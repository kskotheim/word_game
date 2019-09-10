import 'package:flutter/material.dart';
import 'package:word_game/src/models/problem.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class ProblemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PlayBloc _playBloc = BlocProvider.of<PlayBloc>(context);

    return StreamBuilder<Problem>(
        stream: _playBloc.problemBroadcast,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            _playBloc.guessSink.add(InitialProblem());
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _wordOption(snapshot.data, snapshot.data.wordList[0], _playBloc,
                  Colors.black, Colors.white),
              _wordOption(snapshot.data, snapshot.data.wordList[1], _playBloc,
                  Colors.white, Colors.black),
              _problemMetaInfo(snapshot.data.problemData)
            ],
          );
        });
  }

  Widget _wordOption(Problem problem, String word, PlayBloc _playBloc,
      Color bgColor, Color textColor) {
    return Expanded(
      flex: 1,
      child: FlatButton(
        padding: EdgeInsets.zero,
        child: Container(
          child: _buildWordOption(word, textColor),
          color: bgColor,
        ),
        onPressed: () => _submitGuess(problem, word, _playBloc),
      ),
    );
  }

  void _submitGuess(Problem problem, String guess, PlayBloc playBloc) {
    playBloc.guessSink.add(ProblemAndGuess(problem: problem, guess: guess, difficulty: problem.problemData.difficulty));
  }

  Widget _buildWordOption(String word, Color color) {
    return SizedBox.expand(
      child: Center(
        child: Text(word, style: Style.titleTextStyle(color)),
      ),
    );
  }

  Widget _problemMetaInfo(ProblemData data) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Problem Difficulty: ${(10*data.difficulty).round()/10.0}',
                style: Style.BLACK_METADATA_TEXT_STYLE,
              ),
              Text(
                'Score: ${data.score}',
                style: Style.BLACK_METADATA_TEXT_STYLE,
              ),
              data.currentOfTotal[1] !=
                      2 //magic number that means this game is sudden death
                  ? Text(
                      '${data.currentOfTotal[0]} of ${data.currentOfTotal[1]}',
                      style: Style.BLACK_METADATA_TEXT_STYLE,
                    )
                  : Container(),
              data.previousSolution != ''
                  ? Text(
                      'previous solution: ${data.previousSolution}',
                      style: Style.BLACK_METADATA_TEXT_STYLE,
                    )
                  : Container(),
              Container(height:12.0),
              Container(
                color: data.previousSolutionCorrect
                    ? Style.CORRECT_COLOR
                    : Style.INCORRECT_COLOR,
                height: 12.0,
                width: 200.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
