import 'package:flutter/material.dart';
import 'package:word_game/src/resources/style.dart';

import 'package:word_game/src/blocs/game_bloc.dart';
import 'package:word_game/src/blocs/highscore_bloc.dart';
import 'package:word_game/src/blocs/naming_bloc.dart';
import 'package:word_game/src/blocs/bloc_provider.dart';

class NamingPage extends StatefulWidget {
  @override
  _NamingPageState createState() => _NamingPageState();
}

class _NamingPageState extends State<NamingPage> {
  static const double _NAME_FIELD_WIDTH = 200.0;
  static const String _GO_HOME_STRING = 'Ok';
  final BoxDecoration _curvedBorderBoxDecoration = BoxDecoration(
      border: Border.all(color: Colors.black45),
      borderRadius: BorderRadius.all(Radius.circular(20.0)));

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
      child: ListView(

        children: <Widget>[
          Container(height: 140.0,),
          _renameUserSection(),
          Container(height: 100.0,),
          _shareHighScoresSection(),
          Container(height:40.0),
        ],
      ),
    );
  }

  Column _renameUserSection() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: NameField(
                bloc: _namingBloc,
              ),
              width: _NAME_FIELD_WIDTH,
            ),
            Container(
              height: 40.0,
            ),
            _renameUserButton(),
          ],
        );
  }

  Column _shareHighScoresSection() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _highScoreBloc.switchSharedHighScores();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: _highScoreBloc.shareHighScores,
                onChanged: (val) {
                  setState(() {
                    _highScoreBloc.switchSharedHighScores();
                  });
                },
              ),
              Text('Share High Scores'),
            ],
          ),
        ),
        _highScoreBloc.shareHighScores ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Your username will be visible to others.\n\nPlease do not use any personally identifying information.'),
            ),
            Container(height: 20.0,),
             Container(
              child: FlatButton(
                child: Text('Privacy Policy'),
                onPressed: () {
                  //navigate to https://flutterdeveloper.wordpress.com/word-game-privacy-policy/
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              decoration: _curvedBorderBoxDecoration,
            ) 
          ],
        ): Container(),
      ],
    );
  }

  RaisedButton _renameUserButton() {
    return RaisedButton(
      padding: Style.BUTTON_PADDING,
      color: Style.BUTTON_COLOR,
      child: Text(_GO_HOME_STRING, style: Style.BLACK_SUBTITLE_TEXT_STYLE),
      onPressed: () {
        _highScoreBloc.highScoreEvent
            .add(RenameUserEvent(newUsername: _namingBloc.currentUserName));
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
          maxLength: 20,
          onChanged: bloc.changeName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: _USERNAME_INPUT_LABEL_STRING,
              errorText: snapshot.error),
        );
      },
    );
  }
}
