import 'dart:async';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/models/high_score.dart';
import 'package:word_game/src/resources/db.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScoreBloc implements BlocBase {

  static const String _SHARED_PREFS_USERNAME_KEY = 'username';

  String _currentUsername = '';
  String get currentUserName => _currentUsername;
  SharedPreferences _prefs;

  //output for this bloc
  BehaviorSubject<List<HighScore>> _highScoreStream = BehaviorSubject<List<HighScore>>();
  StreamSink get _highScoreSink => _highScoreStream.sink;
  Stream get highScores => _highScoreStream.stream;

  //input for this bloc
  StreamController<HighScoreEvent> _highScoreEventStream = StreamController<HighScoreEvent>();
  StreamSink get highScoreEvent => _highScoreEventStream.sink;

  HighScoreBloc() {
    _highScoreEventStream.stream.listen((event) => _mapEventToState(event));
    highScoreEvent.add(GetHighScores());
    _getUsername();
  }

  void _getUsername() async {
    _prefs = await SharedPreferences.getInstance();
    _currentUsername = _prefs.getString(_SHARED_PREFS_USERNAME_KEY);
  }

  void _mapEventToState(HighScoreEvent event) {
    if (event is GetHighScores) {
      DatabaseManager.db
          .getHighScores()
          .then((highScores) => _highScoreSink.add(highScores));
    }
    if (event is SetHighScore) {
      DatabaseManager.db.saveHighScore(
        HighScore(name: currentUserName, score: event.highScore, time: DateTime.now(), difficulty: event.difficulty)
      ).then((_) => highScoreEvent.add(GetHighScores()));
    }
    if(event is RenameUserEvent){
      _currentUsername = event.newUsername;
      _prefs.setString(_SHARED_PREFS_USERNAME_KEY, event.newUsername);
    }
  }

  @override
  void dispose() {
    _highScoreStream.close();
    _highScoreEventStream.close();
  }
}

//input types for this bloc

abstract class HighScoreEvent {}

class GetHighScores extends HighScoreEvent {}

class SetHighScore extends HighScoreEvent {
  final int highScore;
  final String difficulty;

  SetHighScore({this.highScore, this.difficulty}) : assert(highScore != null, difficulty != null);
}

class RenameUserEvent extends HighScoreEvent{
  final String newUsername;
  RenameUserEvent({this.newUsername}) : assert(newUsername != null);
}
