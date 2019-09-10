import 'dart:convert';


class HighScore{

  static const String _NAME_STRING = 'name';
  static const String _SCORE_STRING = 'score';
  static const String _TIME_STRING = 'time';
  static const String _DIFFICULTY_STRING = 'difficulty';

  final String name;
  final int score;
  final int time;
  final String difficulty;

  HighScore({this.name, this.score, this.time, this.difficulty}){
    assert(this.name != null);
    assert(this.score != null);
    assert(this.time != null);
    assert(this.difficulty != null);
  }

  static HighScore fromString(String highScore) => fromMap(jsonDecode(highScore));

  static List<String> highscoreListToStringList(List<HighScore> scores){
    List<String> toReturn = [];
    scores.forEach((score){
      toReturn.add(score.toString());
    });
    return toReturn;
  }

  static HighScore fromMap(Map<String, dynamic> highscore){
    return HighScore(name: highscore[_NAME_STRING] ?? '', score: highscore[_SCORE_STRING], time: highscore[_TIME_STRING], difficulty: highscore[_DIFFICULTY_STRING]);
  }

  Map<String, dynamic> get toMap => {_NAME_STRING:name, _SCORE_STRING:score, _TIME_STRING:time, _DIFFICULTY_STRING:difficulty};

  
  @override
  String toString() => jsonEncode(toMap, toEncodable: encodeDateTime);

  dynamic encodeDateTime(dynamic item) {
    if(item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}
