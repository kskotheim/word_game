import 'dart:async';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/models/difficulty.dart';
import 'package:word_game/src/models/high_score.dart';
import 'package:word_game/src/resources/db.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';


// Must actually get / set local high scores

class HighScoreBloc implements BlocBase {

  HighScoreType _highScoreType = HighScoreType.recent;
  HighScoreType get highScoreType => _highScoreType;

  bool _shareHighScores = true;
  bool get shareHighScores => _shareHighScores;
  void switchSharedHighScores() => _shareHighScores = !_shareHighScores;

  String _currentUsername = '';
  String get currentUserName => _currentUsername;
  
  static const int _LOCAL_SCORES_CT = 10;
  List<HighScore> _localHighScores = [];

  //output for this bloc
  BehaviorSubject<List<HighScore>> _highScoreStream = BehaviorSubject<List<HighScore>>();
  StreamSink get _highScoreSink => _highScoreStream.sink;
  Stream get highScores => _highScoreStream.stream;

  //input for this bloc
  StreamController<HighScoreEvent> _highScoreEventStream = StreamController<HighScoreEvent>();
  StreamSink get highScoreEvent => _highScoreEventStream.sink;

  SharedPrefsManager _prefsManager;

  HighScoreBloc() {
    _highScoreEventStream.stream.listen((event) => _mapEventToState(event));
    highScoreEvent.add(GetAllHighScores());
    
    _getUsernameAndHighScores();
  }

  void _getUsernameAndHighScores() async {
    _prefsManager = await SharedPrefsManager.getInstance();
    
    _currentUsername = _prefsManager.getUsername();
    
    _localHighScores = _prefsManager.getScores().map((stringScore) => HighScore.fromString(stringScore)).toList();

  }

  void _mapEventToState(HighScoreEvent event) async {
    if (event is GetAllHighScores) {
      _highScoreType = HighScoreType.allTime;
      getAllTimeHighScores().then((highScores) => _highScoreSink.add(highScores));
    }
    if (event is GetRecentHighScores) {
      _highScoreType = HighScoreType.recent;
      getRecentHighScores().then((highScores) => _highScoreSink.add(highScores));
    }
    if (event is GetLocalHighScores) {
      _highScoreType = HighScoreType.local;
      _highScoreSink.add(_localHighScores);
    }
    if (event is SetHighScore) {
      if(_shareHighScores && currentUserName.length > 0){
        saveScorePublic(
          HighScore(name: currentUserName, score: event.highScore, time: DateTime.now().millisecondsSinceEpoch, difficulty: event.difficulty)
        ).then((_) => highScoreEvent.add(GetAllHighScores()));
      }
      bool added = false;
      if(currentUserName.length > 0 && (_localHighScores.length < _LOCAL_SCORES_CT || event.highScore > _localHighScores[_LOCAL_SCORES_CT - 1].score)){
        for(int i=0; (i < _localHighScores.length || (i == _localHighScores.length && _localHighScores.length < _LOCAL_SCORES_CT)) && !added; i++){
          if(i >= _localHighScores.length || event.highScore > _localHighScores[i].score ?? 0){
            added = await insertLocalHighScore(event, i);
          }
        }
      }
    }
    if(event is RenameUserEvent){
      _currentUsername = event.newUsername;
      SharedPrefsManager.getInstance().then((prefs){
        prefs.setUsername(_currentUsername);
      });
    }
  }

  Function get getAllTimeHighScores => DatabaseManager.db.getAllTimeHighScores;
  Function get getRecentHighScores => DatabaseManager.db.getRecentHighScores;
  Function get saveScorePublic => DatabaseManager.db.saveHighScore;
  
  Future<bool> insertLocalHighScore(SetHighScore event, int index) async {
    HighScore score = HighScore(name: currentUserName, score: event.highScore, time: DateTime.now().millisecondsSinceEpoch, difficulty: event.difficulty);
    
    //extend the list if the element to add is at the end
    if(index == _localHighScores.length) {
      _localHighScores.add(score);
    }
    //the element is not at the end
    else {
      bool inserted = false;
      for (int i = minimum( _localHighScores.length, _LOCAL_SCORES_CT - 1 ); i >= 0 && !inserted; i--){
        if(i == index){
          inserted = true;
          _localHighScores[i] = score;
        } else{
          if(_localHighScores[i-1] != null) {
            //extend the list if necessary
            if(i == _localHighScores.length) _localHighScores.add(_localHighScores[i-1]);
            else _localHighScores[i] = _localHighScores[i-1];
          }
        }
      }
    }
    return SharedPrefsManager.getInstance().then((prefs){
      return prefs.setScores(HighScore.highscoreListToStringList(_localHighScores));
    });
  }

  int minimum(int a, int b){
    return a < b ? a : b;
  }

  @override
  void dispose() {
    _highScoreStream.close();
    _highScoreEventStream.close();
  }
}

//input types for this bloc

abstract class HighScoreEvent {}

class GetAllHighScores extends HighScoreEvent {}

class GetRecentHighScores extends HighScoreEvent {}

class GetLocalHighScores extends HighScoreEvent {}

class SetHighScore extends HighScoreEvent {
  final int highScore;
  final String difficulty;

  SetHighScore({this.highScore, this.difficulty}) : assert(highScore != null, difficulty != null);
}

class RenameUserEvent extends HighScoreEvent{
  final String newUsername;
  RenameUserEvent({this.newUsername}) : assert(newUsername != null);
}

enum HighScoreType {
  recent,
  allTime,
  local
}