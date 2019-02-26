
class Difficulty{

  static const String EASY_STRING = 'Easy';
  static const String MEDIUM_STRING = 'Medium';
  static const String HARD_STRING = 'Hard';

  static final Difficulty EASY = Difficulty(name: EASY_STRING, numProblemsInGame: 10, indexRange: [2000,5000]);
  static final Difficulty MEDIUM = Difficulty(name: MEDIUM_STRING, numProblemsInGame: 15, indexRange: [1000,2000]);
  static final Difficulty HARD = Difficulty(name: HARD_STRING, numProblemsInGame: 20, indexRange: [1,1000]);

  final String name;
  final int numProblemsInGame;
  final List<int> indexRange;

  Difficulty({this.name, this.numProblemsInGame, this.indexRange});
}