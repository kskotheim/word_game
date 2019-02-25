import 'dart:async';
import 'package:word_game/src/models/problem.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class PlayBloc implements BlocBase {
  static const int POINTS_INCREASE_PER_CORRECT_ANSWER = 100;

  static const int NUM_PROBLEMS_PER_GAME_EASY = 10;
  static const int NUM_PROBLEMS_PER_GAME_MEDIUM = 15;
  static const int NUM_PROBLEMS_PER_GAME_HARD = 20;
  static const List<int> WORD_RANGE_EASY = [2000, 5000];
  static const List<int> WORD_RANGE_MEDIUM = [1000, 2000];
  static const List<int> WORD_RANGE_HARD = [1, 1000];

  final GameBloc gameBloc;

  //difficulty settings
  int _numberOfProblemsInGame = NUM_PROBLEMS_PER_GAME_EASY;
  List<int> _wordDifficultyRange = WORD_RANGE_EASY;  //the number of indices away paired words are allowed to be

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
      return _problemStreamSink.add(Problem(numberOfProblemsInGame: _numberOfProblemsInGame, wordRange: _wordDifficultyRange));
    }

    if (playBlocInput is ProblemAndGuess) {
      String guess = playBlocInput.guess;
      String solution = playBlocInput.problem.solution;
      List<int> problemCount = playBlocInput.problem.problemData.currentOfTotal;

      bool correct = guess == solution;
      bool finalSolution = problemCount[0] == problemCount[1];
      int currentScore = playBlocInput.problem.problemData.score;
      int scoreIncrease = correct ? POINTS_INCREASE_PER_CORRECT_ANSWER : 0;

      ProblemData newProblemData = ProblemData(
          currentOfTotal: [problemCount[0] + 1, problemCount[1]],
          previousSolution: solution,
          score: currentScore + scoreIncrease,
          previousSolutionCorrect: correct);

      if (!finalSolution)
        _problemStreamSink.add(Problem(problemData: newProblemData, wordRange: _wordDifficultyRange));
      else
        gameBloc.gameButton.add(GameOverEvent(score: currentScore + scoreIncrease));
    }

    if (playBlocInput is SetDifficulty){
      switch (playBlocInput.difficulty){
        case Difficulty.easy:
          _numberOfProblemsInGame = NUM_PROBLEMS_PER_GAME_EASY;
          _wordDifficultyRange = WORD_RANGE_EASY;
        break;
        case Difficulty.medium:
          _numberOfProblemsInGame = NUM_PROBLEMS_PER_GAME_MEDIUM;
          _wordDifficultyRange = WORD_RANGE_MEDIUM;
        break;
        case Difficulty.hard:
          _numberOfProblemsInGame = NUM_PROBLEMS_PER_GAME_HARD;
          _wordDifficultyRange = WORD_RANGE_HARD;
        break;
      }
    }
  }

  void dispose() {
    _guessController.close();
    _problemStreamController.close();
  }

  Difficulty get difficulty {
    if(_numberOfProblemsInGame == NUM_PROBLEMS_PER_GAME_EASY) return Difficulty.easy;
    if(_numberOfProblemsInGame == NUM_PROBLEMS_PER_GAME_MEDIUM) return Difficulty.medium;
    if(_numberOfProblemsInGame == NUM_PROBLEMS_PER_GAME_HARD) return Difficulty.hard;
    else return Difficulty.easy;
  }

  String difficultyString(){
    Difficulty diff = difficulty;
    switch(diff){
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      default:
        return 'Error Finding Difficulty String';
    }
  }
}

enum Difficulty{easy, medium, hard}

//Input type for this bloc

abstract class PlayBlocInput {}

class ProblemAndGuess extends PlayBlocInput {
  final Problem problem;
  final String guess;

  ProblemAndGuess({this.problem, this.guess})
      : assert(problem != null, guess != null);
}

class InitialProblem extends PlayBlocInput {}

class SetDifficulty extends PlayBlocInput {
  final Difficulty difficulty;

  SetDifficulty({this.difficulty}) : assert (difficulty != null);
}