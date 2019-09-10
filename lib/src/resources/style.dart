import 'package:flutter/material.dart';
import 'dart:math';

class Style {
  static const String APP_TITLE = 'Word More Common';

  static final BoxDecoration HOME_SCAFFOLD_DECORATION = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.1, 0.2, 0.8, 0.9],
        colors: [
          Colors.indigo[50],
          Colors.indigo[100],
          Colors.indigo[200],
          Colors.indigo[300],
        ],
      ),
    );

  static const TextStyle BLACK_TITLE_TEXT_STYLE = TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, fontFamily: 'ABeeZee');
  static const TextStyle BLACK_SUBTITLE_TEXT_STYLE = TextStyle(fontSize: 18.0, fontFamily: 'ABeeZee');
  static const TextStyle BLACK_METADATA_TEXT_STYLE = TextStyle(fontSize:16.0, fontFamily: 'Acme');
  static const TextStyle BLACK_METADATA_TEXT_STYLE_ABZ = TextStyle(fontSize:16.0, fontFamily: 'ABeeZee');
  static const TextStyle PRIVACY_POLICY_TEXT_STYLE = TextStyle(fontSize:13.0, fontFamily: 'ABeeZee');

  static const EdgeInsetsGeometry LISTVIEW_PADDING = const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0);

  static const EdgeInsetsGeometry BUTTON_PADDING = const EdgeInsets.all(20.0);
  static final Color BUTTON_COLOR = Colors.orange.shade200;
  
  static const Color CORRECT_COLOR = Colors.green;
  static const Color INCORRECT_COLOR = Colors.redAccent;

  static TextStyle getRandomTitleStyle(){
    Random gen = Random();
    int x = gen.nextInt(3);
    switch( x ){
      case 0:
        return TextStyle(fontFamily: 'Acme', fontSize: 54.0);
      case 1:
        return TextStyle(fontFamily: 'Astloch', fontSize: 54.0);
      case 2:
        return TextStyle(fontFamily: 'PO', fontSize: 54.0);
      case 3:
        return TextStyle(fontFamily: 'Chicle', fontSize: 54.0);
    }
  }

  static ThemeData buildThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.teal.shade100,
      splashColor: Colors.deepOrangeAccent,
    );
  }

  static TextStyle titleTextStyle(Color color) => TextStyle(fontSize:34.0, color: color, fontFamily: 'AbeeZee');

  static Widget button(Function doThis, String title){
    return RaisedButton(
      onPressed: doThis,
      color: null,
      
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: Style.BUTTON_PADDING,
        child: Text(title, style: Style.BLACK_SUBTITLE_TEXT_STYLE,),
      ),
    );
  }
}
