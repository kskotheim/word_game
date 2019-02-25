import 'package:flutter/material.dart';

class Style {
  static const String APP_TITLE = 'Word Game';


  static const TextStyle BLACK_TITLE_TEXT_STYLE = TextStyle(fontSize: 34.0);
  static const TextStyle BLACK_SUBTITLE_TEXT_STYLE = TextStyle(fontSize: 18.0);

  static const EdgeInsetsGeometry BUTTON_PADDING = const EdgeInsets.all(20.0);

  static ThemeData buildThemeData() {
    return ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.green,
    );
  }
}
