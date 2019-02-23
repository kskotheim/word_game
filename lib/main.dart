import 'package:flutter/material.dart';
import 'src/home_page.dart';
import 'src/resources/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Style.APP_TITLE,
      theme: Style.buildThemeData(),
      home: HomePage(title: Style.APP_TITLE),
    );
  }
}


