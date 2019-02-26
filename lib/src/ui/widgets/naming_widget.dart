import 'package:flutter/material.dart';
import 'package:word_game/src/resources/style.dart';

import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';


class NamingPage extends StatefulWidget {
  final String currentName;

  NamingPage({this.currentName});

  @override
  _NamingPageState createState() => _NamingPageState();
}

class _NamingPageState extends State<NamingPage> {

  TextEditingController _nameController;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName ?? '');
  }

  @override
  Widget build(BuildContext context) {

    GameBloc gameBloc =BlocProvider.of<GameBloc>(context);
    HighScoreBloc highScoreBloc =BlocProvider.of<HighScoreBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(child: TextField(controller: _nameController,), width: 200.0,),
        RaisedButton(
          padding: Style.BUTTON_PADDING,
          color: Style.BUTTON_COLOR,
          child: Text('Ok', style: Style.BLACK_SUBTITLE_TEXT_STYLE,), 
          onPressed: (){
            highScoreBloc.highScoreEvent.add(RenameUserEvent(newUsername: _nameController.text));
            gameBloc.gameButton.add(GoHomeEvent());
          },
        )
      ],
    );
  }
}