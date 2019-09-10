import 'dart:math';
import 'package:english_words/english_words.dart';

class Problem{
  List<String> wordList;
  String solution;

  int numberOfProblemsInGame;

  List<double> wordRange;

  //meta-data to contexualize the problem in the game
  ProblemData problemData;

  Problem({this.problemData, this.numberOfProblemsInGame, this.wordRange}){
    assert(problemData != null || numberOfProblemsInGame != null);
    //if no problem data is passed, it is the initial problem
    if (problemData == null){
      problemData = ProblemData(previousSolution: '', score: 0, currentOfTotal: [1,numberOfProblemsInGame], previousSolutionCorrect: true);
    }

    int _firstIndex = _getRandomIndex();
    int _secondIndex = _getRandomIndex();
    double ratio = 1;

    while(_firstIndex == _secondIndex) _secondIndex = _getRandomIndex();

    //assert it is not null somewhere
    if(wordRange != null){
      
      _firstIndex > _secondIndex 
        ? ratio = (1.0*_firstIndex)/_secondIndex 
        : ratio = (1.0*_secondIndex)/_firstIndex;

      while (ratio < wordRange[0] || ratio > wordRange[1]){
        _firstIndex = _getRandomIndex();
        _secondIndex = _getRandomIndex();
        while(_firstIndex == _secondIndex) _secondIndex = _getRandomIndex();

        _firstIndex > _secondIndex 
          ? ratio = (1.0*_firstIndex)/_secondIndex 
          : ratio = (1.0*_secondIndex)/_firstIndex;
      }
    }
    problemData.difficulty = (1.0/(ratio - 1));

    wordList = [];
    wordList.add(all[_firstIndex]);
    wordList.add(all[_secondIndex]);

    solution = all[min(_firstIndex, _secondIndex)];
  }

  int _getRandomIndex() => (Random().nextDouble() * (all.length - 1)).ceil();
}

class ProblemData{
  final String previousSolution;
  final int score;
  final List<int> currentOfTotal;
  final bool previousSolutionCorrect;
  double difficulty = 0;    //this is set when the problem is created

  ProblemData({this.previousSolution, this.score, this.currentOfTotal, this.previousSolutionCorrect}){
    assert(currentOfTotal != null);
    assert(score != null);
    assert(previousSolution != null);
    assert(previousSolutionCorrect != null);
  }
}
