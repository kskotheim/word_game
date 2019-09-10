
class Difficulty{

  static const String EASY_STRING = 'Easy';
  static const String MEDIUM_STRING = 'Medium';
  static const String HARD_STRING = 'Hard';
  static const String SUDDEN_DEATH_STRING = '3 Lives';

  static final Difficulty EASY = Difficulty(name: EASY_STRING, numProblemsInGame: 10, ratioRange: [1.5,5000], suddenDeath: false);
  static final Difficulty MEDIUM = Difficulty(name: MEDIUM_STRING, numProblemsInGame: 15, ratioRange: [1.3,2.5] ,suddenDeath: false);
  static final Difficulty HARD = Difficulty(name: HARD_STRING, numProblemsInGame: 20, ratioRange: [1,1.5], suddenDeath: false);
  static final Difficulty SUDDEN_DEATH = Difficulty(name:SUDDEN_DEATH_STRING, numProblemsInGame: 2, ratioRange: [1, 5000], suddenDeath: true);

  final String name;
  final int numProblemsInGame;
  final List<double> ratioRange;
  final bool suddenDeath;

  Difficulty({this.name, this.numProblemsInGame, this.ratioRange, this.suddenDeath});
}