import 'package:flutter/material.dart';

//double get opacity40 => 0.4 / 0xFF0063C6;
final Color opositePrimary = Color(4292299776);
final ThemeData walterTheme = new ThemeData(
    primaryColor: Color(0xFF0063C6),
    primaryColorLight: Color(0xFF0063C6).withOpacity(0.1),
    //dialog button
    accentColor: Color(0xFF003473),
    //all background color
    //canvasColor: Color(0xFFF1F2F2),
    backgroundColor: Color(4290362042),
    scaffoldBackgroundColor: Color(0xFFF1F2F2),
    //cardTheme: CardTheme(color: Color(0xFFF1F2F2)),
    cardColor: Colors.white,
    primaryColorDark: Color(0xFFB9BABA),
    textTheme: TextTheme(
      //ListTitle(title)
      subtitle: TextStyle(color: Colors.black87),
      //Menu texto
      body2: TextStyle(color: Colors.white),
      //Calentar title, widget Text()
      //body1: TextStyle(color: Color(0xFF0063C6)),
      // subtitle1: TextStyle(color: Colors.black87),
      // //Menu texto
      // bodyText1: TextStyle(color: Colors.black87),
      // //Calentar title, widget Text()
      // bodyText2: TextStyle(color: Colors.black54),
    ),
    appBarTheme: AppBarTheme(
      //AppBar
      color: Color(0xFF0063C6),
      //icon
      actionsIconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      //iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    dividerTheme: DividerThemeData(color: Color(0xFF0063C6), thickness: 2),
    dividerColor: Color(0xFF0063C6).withOpacity(0.4),
    //tabBarTheme: TabBarTheme(labelColor: Color(0xFF003473)),
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Color(0xFF003473)),
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    //backgroundColor: Color(0xFFF1F2F2),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      filled: true,
      contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
    ));
