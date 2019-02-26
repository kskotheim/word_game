import 'dart:async';
import 'package:word_game/src/blocs/bloc_provider.dart';

class GameBloc implements BlocBase{

  int _finalScore = 0;
  int get finalScore => _finalScore;
  
  //Stream to handle the game's status (which page to render): output of Bloc
  StreamController<GameStatus> _gameStatusController = StreamController<GameStatus>();
  StreamSink<GameStatus> get _gameStatusSink => _gameStatusController.sink;
  Stream<GameStatus> get gameStatus => _gameStatusController.stream;

  //Stream to handle button events: input to Bloc
  StreamController _gameButtonController = StreamController();
  StreamSink get gameButton =>_gameButtonController.sink;

  GameBloc(){
    _gameButtonController.stream.listen(_mapEventToState);
    gameButton.add(GoHomeEvent());
  }

  void _mapEventToState(event){
    if(event is PlayGameEvent){
      _gameStatusSink.add(GameStatus.playing);
    }
    if (event is GoHomeEvent){
      _gameStatusSink.add(GameStatus.home);
    }
    if(event is GameOverEvent){
      _finalScore = event.score;
      _gameStatusSink.add(GameStatus.ending);
    }
    if(event is SettingsEvent){
      _gameStatusSink.add(GameStatus.settings);
    }
    if(event is HighScoresEvent){
      _gameStatusSink.add(GameStatus.highScores);
    }
    if(event is NameButtonEvent){
      _gameStatusSink.add(GameStatus.naming);
    }
  }

  void dispose(){
    _gameStatusController.close();
    _gameButtonController.close();
  }
}


//Input events and output types for this bloc
abstract class GameEvent{}

class PlayGameEvent extends GameEvent{}

class SettingsEvent extends GameEvent{}

class GoHomeEvent extends GameEvent{}

class GameOverEvent extends GameEvent{
  final int score;
  GameOverEvent({this.score}) : assert(score != 0);
}

class HighScoresEvent extends GameEvent{}

class NameButtonEvent extends GameEvent{}

enum GameStatus { home, settings, playing, ending, highScores, naming }
