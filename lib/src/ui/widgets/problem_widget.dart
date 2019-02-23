import 'package:flutter/material.dart';
import 'package:word_game/src/models/problem.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:word_game/src/blocs/play_bloc.dart';


class ProblemWidget extends StatelessWidget {

  final PlayBloc playBloc;

  ProblemWidget({this.playBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Problem>(
      stream: playBloc.problemStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: _buildWordOption(snapshot.data.wordList[0]),
              onPressed: () => _submitGuess(snapshot.data, snapshot.data.wordList[0]),
            ),
            FlatButton(
              child: _buildWordOption(snapshot.data.wordList[1]),
              onPressed: () => _submitGuess(snapshot.data, snapshot.data.wordList[1]),
            ),
            Column(
              children: <Widget>[
                Text('Score: ${snapshot.data.problemData.score}'),
                Text('${snapshot.data.problemData.currentOfTotal[0]} of ${snapshot.data.problemData.currentOfTotal[1]}'),
                snapshot.data.problemData.previousSolution != '' ? Text('previous solution: ${snapshot.data.problemData.previousSolution}') : Container()
              ],
            )

          ],
        );
      }
    );
  }

  void _submitGuess(Problem problem, String guess){
    playBloc.guessSink.add(ProblemAndGuess(problem: problem, guess: guess));
  }

  Text _buildWordOption(String word) => Text(word, style: Style.BLACK_TITLE_TEXT_STYLE,);
}