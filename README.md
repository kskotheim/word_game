# word_game

This is a simple word game built using the Bloc pattern to handle state. There are two "main" blocs - the GameBloc controls what state of play the app is in, home, playing, ending, or in the settings screen. The PlayBloc has a reference to the GameBloc, and receives guesses, calculates the score, and generates new problems as the game progresses. When the PlayBloc notices that the game is over, it dumps a GameOverEvent with the final score into the GameBloc's sink. As there are no stateful widgets to be found in this app (I hope), all dynamic functionality is handled in Streams split up into individual Blocs for each screen or function. 

The player is given two random words, and must guess which word of a pair is more common. The difficulty sets the range of possible use-frequency ratios for the random words selected. 

Random words are generated from the [english words package](https://pub.dartlang.org/packages/english_words)
