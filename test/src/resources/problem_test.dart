import 'package:flutter_test/flutter_test.dart';

import 'package:word_game/src/models/problem.dart';

import 'package:english_words/english_words.dart';


main(){
  test('problem is generated with 2 unique words and a solution', (){
    Problem problem = Problem();
    expect(problem.wordList.length, 2);
    expect(problem.wordList[0] == problem.wordList[1], false);
    expect(problem.solution == null, false);
    expect(all.indexOf(problem.wordList[0]) == problem.solution || all.indexOf(problem.wordList[1]) == problem.solution, true);
  });

  test('english words package has at least 4330 words', (){
    expect(all.length > 4330, true);
  });



}
