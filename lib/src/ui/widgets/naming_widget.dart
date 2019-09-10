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
          Container(height: 100.0,),
          _renameUserSection(),
          Container(height: 60.0,),
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
              height: 20.0,
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
              Text('Share High Scores',
              style: Style.BLACK_METADATA_TEXT_STYLE_ABZ),
            ],
          ),
        ),
        _highScoreBloc.shareHighScores ? Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'Your username will be visible to others.\n\nPlease do not use any personally identifying information.',
                  style: Style.BLACK_METADATA_TEXT_STYLE_ABZ,),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  'PRIVACY POLICY: The Word More Common does not collect or store any personally identifying information. The only information we collect in our database is a list of the scores, including the username of the user for each score. We collect this information for the sole purpose of displaying recent and all-time high scores in the app. Scores kept in this database may be deleted at any time for any reason. For more information contact Kris at kris@braketrack.com.',
                  style: Style.PRIVACY_POLICY_TEXT_STYLE),
            ),
            // Container(height: 20.0,),
            //  Container(
            //   child: FlatButton(
            //     child: Text('Privacy Policy'),
            //     onPressed: () {
            //       //navigate to https://flutterdeveloper.wordpress.com/word-game-privacy-policy/
            //       Navigator.pushNamed(context, '/privacy');
            //     },
            //   ),
            //   decoration: _curvedBorderBoxDecoration,
            // ) 
          ],
        ): Container(),
      ],
    );
  }

  RaisedButton _renameUserButton() {
    return Style.button(renameUser, 'OK');
  }

  void renameUser(){
    _highScoreBloc.highScoreEvent
        .add(RenameUserEvent(newUsername: _namingBloc.currentUserName));
    _gameBloc.gameButton.add(GoHomeEvent());
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
