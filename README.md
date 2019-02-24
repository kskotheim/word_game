# word_game

This is a demonstration of using the Bloc pattern to handle state. There are two blocs - the GameBloc controls what state of play the app is in, home, playing, ending, or in the settings screen. The PlayBloc has a reference to the GameBloc, and receives guesses, calculates the score, and generates new problems as the game progresses. When the PlayBloc notices that the game is over, it dumps a GameOverEvent with the final score into the GameBloc's sink. 

The player must guess which word of a pair is more common. A game is 10 guesses.

Random words are generated from the [english words package](https://pub.dartlang.org/packages/english_words)
