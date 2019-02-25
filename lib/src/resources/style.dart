import 'package:flutter/material.dart';

class Style {
  static const String APP_TITLE = 'Word Game';


  static const TextStyle BLACK_TITLE_TEXT_STYLE = TextStyle(fontSize: 34.0);
  static const TextStyle BLACK_SUBTITLE_TEXT_STYLE = TextStyle(fontSize: 18.0);
  static const TextStyle BLACK_METADATA_TEXT_STYLE = TextStyle(fontSize:16.0);

  static const EdgeInsetsGeometry BUTTON_PADDING = const EdgeInsets.all(20.0);
  static final Color BUTTON_COLOR = Colors.greenAccent.shade100;
  
  static const Color CORRECT_COLOR = Colors.green;
  static const Color INCORRECT_COLOR = Colors.redAccent;

  static ThemeData buildThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
      splashColor: Colors.greenAccent,
    );
  }
}
