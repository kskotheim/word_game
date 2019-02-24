import 'dart:async';
import 'package:word_game/src/models/problem.dart';
import 'game_bloc.dart';
import 'bloc_provider.dart';

class PlayBloc implements BlocBase{

  final GameBloc gameBloc;

  //Stream to display the current problem and problem data: Output of Bloc
  StreamController<Problem> _problemStreamController = StreamController<Problem>();
  StreamSink get _problemStreamSink => _problemStreamController.sink;
  Stream get problemStream => _problemStreamController.stream;

  //Stream to take button presses and translate that to a new problem and problem data, or end the game: Input of Bloc
  StreamController<ProblemAndGuess> _guessController = StreamController<ProblemAndGuess>();
  StreamSink get guessSink => _guessController.sink;


  PlayBloc({this.gameBloc}){
    _guessController.stream.listen(_mapEventToState);
    _problemStreamSink.add(Problem());
  }

  void _mapEventToState(ProblemAndGuess problemAndGuess){
    String guess = problemAndGuess.guess;
    String solution = problemAndGuess.problem.solution;
    List<int> problemCount = problemAndGuess.problem.problemData.currentOfTotal;

    bool correct = guess == solution;
    bool finalSolution = problemCount[0] == problemCount[1];
    int currentScore = problemAndGuess.problem.problemData.score;
    int scoreIncrease = correct ? 100 : 0;

    ProblemData newProblemData = ProblemData(currentOfTotal: [problemCount[0] + 1,problemCount[1]], previousSolution: solution, score: currentScore + scoreIncrease);

    if(!finalSolution)
      _problemStreamSink.add(Problem(problemData: newProblemData));
    else
      gameBloc.gameButton.add(GameOverEvent(score: currentScore + scoreIncrease));
  
  }


  void dispose(){
    _guessController.close();
    _problemStreamController.close();
  }
}


//Input type for this bloc
class ProblemAndGuess{

  final Problem problem;
  final String guess;

  ProblemAndGuess({this.problem, this.guess}) : assert(problem != null, guess != null);
}