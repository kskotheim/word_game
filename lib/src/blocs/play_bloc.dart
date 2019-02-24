import 'dart:async';
import 'package:word_game/src/models/problem.dart';
import 'game_bloc.dart';
import 'bloc_provider.dart';

class PlayBloc implements BlocBase {
  final GameBloc gameBloc;

  //Stream to display the current problem and problem data: Output of Bloc
  StreamController<Problem> _problemStreamController = StreamController<Problem>();
  StreamSink get _problemStreamSink => _problemStreamController.sink;
  Stream problemBroadcast;

  //Stream to take button presses and translate that to a new problem and problem data, or end the game: Input of Bloc
  StreamController<PlayBlocInput> _guessController = StreamController<PlayBlocInput>();
  StreamSink get guessSink => _guessController.sink;

  PlayBloc({this.gameBloc}) {
    problemBroadcast = _problemStreamController.stream.asBroadcastStream();
    _guessController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PlayBlocInput playBlocInput) {
    if (playBlocInput is InitialProblem) {
      return _problemStreamSink.add(Problem());
    }

    String guess = playBlocInput.guess;
    String solution = playBlocInput.problem.solution;
    List<int> problemCount = playBlocInput.problem.problemData.currentOfTotal;

    bool correct = guess == solution;
    bool finalSolution = problemCount[0] == problemCount[1];
    int currentScore = playBlocInput.problem.problemData.score;
    int scoreIncrease = correct ? 100 : 0;

    ProblemData newProblemData = ProblemData(
        currentOfTotal: [problemCount[0] + 1, problemCount[1]],
        previousSolution: solution,
        score: currentScore + scoreIncrease);

    if (!finalSolution)
      _problemStreamSink.add(Problem(problemData: newProblemData));
    else
      gameBloc.gameButton.add(GameOverEvent(score: currentScore + scoreIncrease));
  }

  void dispose() {
    _guessController.close();
    _problemStreamController.close();
  }
}

//Input type for this bloc

abstract class PlayBlocInput {
  Problem problem;
  String guess;
}

class ProblemAndGuess extends PlayBlocInput {
  final Problem problem;
  final String guess;

  ProblemAndGuess({this.problem, this.guess})
      : assert(problem != null, guess != null);
}

class InitialProblem extends PlayBlocInput {
  final Problem problem = Problem();
  final String guess = '';
}
