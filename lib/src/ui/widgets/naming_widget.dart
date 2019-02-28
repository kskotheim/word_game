import 'package:flutter/material.dart';
import 'package:word_game/src/resources/style.dart';

import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/naming_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class NamingPage extends StatelessWidget {
  static const double _NAME_FIELD_WIDTH = 200.0;
  static const String _GO_HOME_STRING = 'Ok';

  GameBloc _gameBloc;
  HighScoreBloc _highScoreBloc;
  NamingBloc _namingBloc;

  @override
  Widget build(BuildContext context) {
    _gameBloc = BlocProvider.of<GameBloc>(context);
    _highScoreBloc = BlocProvider.of<HighScoreBloc>(context);
    _namingBloc = NamingBloc();

    return BlocProvider(
      bloc: _namingBloc,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            child: NameField(
              bloc: _namingBloc,
            ),
            width: _NAME_FIELD_WIDTH,
          ),
          _renameUserButton()
        ],
      ),
    );
  }

  RaisedButton _renameUserButton() {
    return RaisedButton(
      padding: Style.BUTTON_PADDING,
      color: Style.BUTTON_COLOR,
      child: Text(_GO_HOME_STRING, style: Style.BLACK_SUBTITLE_TEXT_STYLE),
      onPressed: () {
        
        _highScoreBloc.highScoreEvent.add(RenameUserEvent(newUsername: _namingBloc.currentUserName));
        _gameBloc.gameButton.add(GoHomeEvent());
      },
    );
  }
}

class NameField extends StatelessWidget {
  static const String _USERNAME_INPUT_LABEL_STRING = 'Your Username';

  NameField({this.bloc});

  final NamingBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.namingString,
      builder: (context, snapshot) {
        return TextField( 
          onChanged: bloc.changeName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: _USERNAME_INPUT_LABEL_STRING, errorText: snapshot.error),
        );
      },
    );
  }
}
