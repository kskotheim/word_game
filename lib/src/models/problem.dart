import 'dart:math';
import 'package:english_words/english_words.dart';

class Problem{
  static const int NUMBER_OF_PROBLEMS_IN_GAME = 10;
  List<String> wordList;
  String solution;

  //meta-data to contexualize the problem in the game
  ProblemData problemData;

  Problem({this.problemData}){
    //if no problem data is passed, mock some up
    if (problemData == null){
      problemData = ProblemData(previousSolution: '', score: 0, currentOfTotal: [0,NUMBER_OF_PROBLEMS_IN_GAME]);
    }

    int _firstIndex = _getRandomIndex();
    int _secondIndex = _getRandomIndex();

    while(_firstIndex == _secondIndex) _secondIndex = _getRandomIndex();

    wordList = [];
    wordList.add(all[_firstIndex]);
    wordList.add(all[_secondIndex]);

    solution = all[min(_firstIndex, _secondIndex)];
  }

  int _getRandomIndex() => (Random().nextDouble() * all.length).round();
}

class ProblemData{
  final String previousSolution;
  final int score;
  final List<int> currentOfTotal;

  ProblemData({this.previousSolution, this.score, this.currentOfTotal}){
    assert(currentOfTotal != null);
    assert(score != null);
    assert(previousSolution != null);
  }
}
