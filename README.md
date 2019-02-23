# word_game

This is a demonstration of using the Bloc pattern to handle state. There are two blocs - the game_bloc controls what state of play the app is in, home, playing, ending, or in the settings screen. The play_bloc has a reference to the game_bloc, and receives guesses, calculates the score, and generates new problems as the game progresses. When the play_bloc notices that the game is over, it dumps a GameOverEvent with the final score into the game_bloc's sink. 
