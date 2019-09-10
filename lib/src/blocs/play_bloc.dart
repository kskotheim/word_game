import 'dart:async';
import 'package:word_game/src/models/problem.dart';
import 'package:word_game/src/models/difficulty.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:audioplayers/audio_cache.dart';


class PlayBloc implements BlocBase {
  static const int POINTS_INCREASE_PER_CORRECT_ANSWER = 100;
  static AudioCache player = AudioCache();

  final GameBloc gameBloc;
  final bool hasSound;

  //difficulty settings
  Difficulty _difficulty = Difficulty.EASY;

  //sudden death settings
  int _lives = 3;

  //Stream to display the current problem and problem data: Output of Bloc
  StreamController<Problem> _problemStreamController = StreamController<Problem>();
  StreamSink get _problemStreamSink => _problemStreamController.sink;
  Stream problemBroadcast;

  //Stream to take button presses and translate that to a new problem and problem data, or end the game: Input of Bloc
  StreamController<PlayBlocInput> _guessController = StreamController<PlayBlocInput>();
  StreamSink get guessSink => _guessController.sink;

  PlayBloc({this.gameBloc, this.hasSound}) {
    problemBroadcast = _problemStreamController.stream.asBroadcastStream();
    _guessController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PlayBlocInput playBlocInput) {
    if (playBlocInput is InitialProblem) {
      return _problemStreamSink.add(Problem(numberOfProblemsInGame: _difficulty.numProblemsInGame, wordRange: _difficulty.ratioRange));
    }

    if (playBlocInput is ProblemAndGuess) {
      _handleProblemAndGuess(playBlocInput);
    }

    if (playBlocInput is SetDifficulty){
      _difficulty = playBlocInput.difficulty;
    }
  }

  void _handleProblemAndGuess(ProblemAndGuess playBlocInput) {
    String guess = playBlocInput.guess;
    String solution = playBlocInput.problem.solution;
    List<int> problemCount = playBlocInput.problem.problemData.currentOfTotal;
    
    bool correct = guess == solution;
    bool finalSolution = problemCount[0] == problemCount[1];
    int currentScore = playBlocInput.problem.problemData.score;
    //tie score increase to difficulty
    int scoreIncrease = correct ? POINTS_INCREASE_PER_CORRECT_ANSWER + playBlocInput.difficulty.round(): 0;
    
    ProblemData newProblemData = ProblemData(
        currentOfTotal: [problemCount[0] + ((_difficulty.suddenDeath ?? false) ? 0 : 1), problemCount[1]],
        previousSolution: solution,
        score: currentScore + scoreIncrease,
        previousSolutionCorrect: correct);

    Problem newProblem = Problem(problemData: newProblemData, wordRange: _difficulty.ratioRange);
    
    if(gameBloc.soundOn){
      if(correct) player.play('positive.wav');
      else player.play('negative.wav');
    }
    if(_difficulty.suddenDeath && !correct) {
      _lives--;
    } 
    if (!finalSolution && (!_difficulty.suddenDeath || _lives >0)){
      _problemStreamSink.add(newProblem);
    } else {
      _lives = 3;
      gameBloc.gameButton.add(GameOverEvent(score: currentScore + scoreIncrease));
      if(gameBloc.soundOn) player.play('applause.mp3');
    }
  }

  String get difficultyName => _difficulty.name;

  void dispose() {
    _guessController.close();
    _problemStreamController.close();
  }

}

//Input type for this bloc

abstract class PlayBlocInput {}

class ProblemAndGuess extends PlayBlocInput {
  final Problem problem;
  final String guess;
  final double difficulty;

  ProblemAndGuess({this.problem, this.guess, this.difficulty}){
      assert(problem != null);
      assert(guess != null);
      assert(difficulty != null);
  }
}

class InitialProblem extends PlayBlocInput {}

class SetDifficulty extends PlayBlocInput {
  final Difficulty difficulty;

  SetDifficulty({this.difficulty}) : assert (difficulty != null);
}
