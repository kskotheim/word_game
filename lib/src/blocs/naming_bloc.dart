import 'package:word_game/src/blocs/bloc_provider.dart';
import 'dart:async';

class NamingBloc implements BlocBase {

  static String _currentUserName = '';
  String get currentUserName => _currentUserName;

  static bool _currentUsernameOk = true;
  bool get currentUsernameOk => _currentUsernameOk;

  StreamController<String> _namingStringController =StreamController<String>();
  Stream<String> get namingString => _namingStringController.stream.transform(nameValidator);
  Function(String) get changeName => _namingStringController.sink.add;


  final nameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink){
      if( !(name.split(' ').map((name) => _BAD_WORDS.contains(name.toLowerCase())).toList().contains(true)) ) {
        _currentUserName = name;
        sink.add(name);
      }
      else {
        _currentUsernameOk = false;
        _currentUserName = '';
        sink.addError('(╯°□°）╯︵ ┻━┻');
      }
    }
  );


  @override
  void dispose() {
    _namingStringController.close();
  }





















  static final List<String> _BAD_WORDS = [

    'anal',
    'anus',
    'arse',
    'ass',
    'assfucker',
    'asshole',
    'assshole',
    'bastard',
    'bitch',
    'boong',
    'cock',
    'cockfucker',
    'cocksuck',
    'cocksucker',
    'coon',
    'coonnass',
    'crap',
    'cunt',
    'cyberfuck',
    'damn',
    'darn',
    'dick',
    'dirty',
    'douche',
    'dummy',
    'erect',
    'erection',
    'erotic',
    'escort',
    'fag',
    'faggot',
    'fuck',
    'Fuckoff',
    'fuckyou',
    'fuckass',
    'fuckhole',
    'gook',
    'hardcore',
    'homoerotic',
    'hore',
    'lesbian',
    'lesbians',
    'motherfuck',
    'motherfucker',
    'negro',
    'nigger',
    'orgasim',
    'orgasm',
    'penis',
    'penisfucker',
    'piss',
    'porn',
    'porno',
    'pornography',
    'pussy',
    'retard',
    'sadist',
    'sex',
    'sexy',
    'shit',
    'slut',
    'suck',
    'tits',
    'viagra',
    'whore',
    'xxx',
  ];

}