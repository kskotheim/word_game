import 'package:flutter/material.dart';
import 'package:word_game/src/blocs/play_bloc.dart';
import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';
import 'package:word_game/src/resources/style.dart';
import 'package:word_game/src/models/difficulty.dart';
import 'package:audioplayers/audio_cache.dart';


class SettingsWidget extends StatelessWidget {
  static const double SETTINGS_BUTTON_WIDTH = 140.0;
  static const double SETTINGS_BUTTON_HEIGHT = 80.0;

  PlayBloc playBloc;
  GameBloc gameBloc;

  @override
  Widget build(BuildContext context) {
    playBloc = BlocProvider.of<PlayBloc>(context);
    gameBloc = BlocProvider.of<GameBloc>(context);
 
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _difficultyButton(Difficulty.EASY, true),
        _difficultyButton(Difficulty.MEDIUM, true),
        _difficultyButton(Difficulty.HARD, true),
        StreamBuilder<List<String>>(
          stream: gameBloc.purchaseDetailsStream,
          builder: (context, snapshot){
            bool hasPurchase;
            if(snapshot.hasData)
              if(snapshot.data.contains('3_lives_mode')) hasPurchase = true;
              else hasPurchase = false;
            else return CircularProgressIndicator();
            return  _difficultyButton(Difficulty.SUDDEN_DEATH, hasPurchase);
          },
        ),
        FlatButton(
          child: Text('restore purchases'),
          onPressed: gameBloc.queryPastPurchases,
        )
      ],
    );
  }


  RaisedButton _difficultyButton(Difficulty difficulty, bool available){
    AudioCache _player = AudioCache();

    return RaisedButton(
      // color: Style.BUTTON_COLOR,
      child: Container(
        width: SETTINGS_BUTTON_WIDTH,
        height: SETTINGS_BUTTON_HEIGHT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            playBloc.difficultyName == difficulty.name ? Icon(Icons.check) : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(difficulty.name, style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
                available ? Container() : Text('\$2.99')
              ],
            ),
            available ? Container() : Icon(Icons.add_shopping_cart)
          ],
        ),
      ),
      onPressed: (){
        if(available){
          playBloc.guessSink.add(SetDifficulty(difficulty: difficulty));
          gameBloc.gameButton.add(GoHomeEvent());
        } else {
          gameBloc.makePurchase('3_lives_mode').then((bool success){
            if(success && gameBloc.soundOn) _player.play('applause.mp3');
          });
        }
        
      },
    );
  }
}