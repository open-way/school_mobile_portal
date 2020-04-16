import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
  accentColor: Colors.white,
  iconTheme: IconThemeData(color: Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: TextStyle(fontSize: 10, height: 1),
    alignLabelWithHint: true,
    isDense: false,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Colors.white)),
    filled: true,
    contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
  ),
  textTheme: TextTheme(
    title: TextStyle(color: Colors.white),
    subtitle: TextStyle(color: Colors.white),
    body1: TextStyle(color: Colors.white),
    body2: TextStyle(color: Colors.white),
    subhead: TextStyle(color: Colors.white),
    display1: TextStyle(color: Colors.white),
    display2: TextStyle(color: Colors.white),
    display3: TextStyle(color: Colors.white),
    display4: TextStyle(color: Colors.white),
    headline: TextStyle(color: Colors.white),
    // headline6: TextStyle(color: Color(0xff40bf7a)),
    // subtitle2: TextStyle(color: Colors.white),
    // subtitle1: TextStyle(color: Color(0xff40bf7a)),
  ),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(color: Color(0xFF1D1D1B)),
  scaffoldBackgroundColor: Color(0xFF1D1D1B),
  canvasColor: Color(0xFF1D1D1B),
  backgroundColor: Color(0xFF1D1D1B),
);
