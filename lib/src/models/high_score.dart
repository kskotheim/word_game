
class HighScore{

  static const String _NAME_STRING = 'name';
  static const String _SCORE_STRING = 'score';
  static const String _TIME_STRING = 'time';
  static const String _DIFFICULTY_STRING = 'difficulty';

  final String name;
  final int score;
  final DateTime time;
  final String difficulty;

  HighScore({this.name, this.score, this.time, this.difficulty}){
    assert(this.name != null);
    assert(this.score != null);
    assert(this.time != null);
    assert(this.difficulty != null);
  }

  Map<String, dynamic> get toJson => {_NAME_STRING:name, _SCORE_STRING:score, _TIME_STRING:time, _DIFFICULTY_STRING:difficulty};

  static HighScore fromJson(Map<String, dynamic> highscore){
    return HighScore(name: highscore[_NAME_STRING] ?? '', score: highscore[_SCORE_STRING], time: highscore[_TIME_STRING], difficulty: highscore[_DIFFICULTY_STRING]);
  }
}
