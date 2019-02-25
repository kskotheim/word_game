import 'dart:math';
import 'package:english_words/english_words.dart';

class Problem{
  List<String> wordList;
  String solution;

  int numberOfProblemsInGame;
  List<int> wordRange;

  //meta-data to contexualize the problem in the game
  ProblemData problemData;

  Problem({this.problemData, this.numberOfProblemsInGame, this.wordRange}){
    assert(problemData != null || numberOfProblemsInGame != null);
    //if no problem data is passed, mock some up
    if (problemData == null){
      problemData = ProblemData(previousSolution: '', score: 0, currentOfTotal: [1,numberOfProblemsInGame]);
    }

    int _firstIndex = _getRandomIndex();
    int _secondIndex = _getRandomIndex();

    while(_firstIndex == _secondIndex) _secondIndex = _getRandomIndex();
    
    if(wordRange != null){
      int dist = (_firstIndex - _secondIndex).abs();
      while (dist < wordRange[0] || dist > wordRange[1]){
        _secondIndex = _getRandomIndex();
        dist = (_firstIndex - _secondIndex).abs();
      }
    }

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
