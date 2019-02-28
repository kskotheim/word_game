import 'package:flutter/material.dart';

class Style {
  static const String APP_TITLE = 'Word Game';


  static const TextStyle BLACK_TITLE_TEXT_STYLE = TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold);
  static const TextStyle BLACK_SUBTITLE_TEXT_STYLE = TextStyle(fontSize: 18.0);
  static const TextStyle BLACK_METADATA_TEXT_STYLE = TextStyle(fontSize:16.0);

  static const EdgeInsetsGeometry LISTVIEW_PADDING = const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0);

  static const EdgeInsetsGeometry BUTTON_PADDING = const EdgeInsets.all(20.0);
  static final Color BUTTON_COLOR = Colors.orange.shade50;
  
  static const Color CORRECT_COLOR = Colors.green;
  static const Color INCORRECT_COLOR = Colors.redAccent;

  static ThemeData buildThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.teal.shade100,
      splashColor: Colors.deepOrangeAccent,
    );
  }
}
