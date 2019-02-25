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
          if(snapshot.data == null) {
            _playBloc.guessSink.add(InitialProblem());
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _wordOption(0, snapshot.data, _playBloc),
              _wordOption(1, snapshot.data, _playBloc),
              _problemMetaInfo(snapshot.data.problemData)
            ],
          );
        });
  }

  FlatButton _wordOption(int index, Problem problem, PlayBloc _playBloc) {
    return FlatButton(
      child: _buildWordOption(problem.wordList[index]),
      onPressed: () =>
          _submitGuess(problem, problem.wordList[index], _playBloc),
    );
  }

  void _submitGuess(Problem problem, String guess, PlayBloc playBloc) {
    playBloc.guessSink.add(ProblemAndGuess(problem: problem, guess: guess));
  }

  Widget _buildWordOption(String word) {
      return Padding(
        padding: Style.BUTTON_PADDING,
        child: Text(word, style: Style.BLACK_TITLE_TEXT_STYLE),
      );
  }
  Column _problemMetaInfo(ProblemData data) {
    return Column(
      children: <Widget>[
        Text('Score: ${data.score}'),
        Text('${data.currentOfTotal[0]} of ${data.currentOfTotal[1]}'),
        data.previousSolution != ''
            ? Text('previous solution: ${data.previousSolution}')
            : Container()
      ],
    );
  }
}
