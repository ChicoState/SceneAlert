import 'package:flutter/material.dart';

  //ThemeData darkTheme = ThemeData.dark();
  ThemeData darkTheme = 
    ThemeData(//.dark().copyWith(
      accentColor: Colors.grey[900],
      primaryColor: Color.fromARGB( 255, 49, 182, 235 ),
      primaryTextTheme: 
        TextTheme(
          title: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ), )
        ),
      appBarTheme: 
        AppBarTheme(
          color: Colors.grey[900],
          textTheme:
            TextTheme(
              body1: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ), )
            ),
        ),
      primaryIconTheme:
        IconThemeData(
          color: Colors.white,
        ),
      accentIconTheme:
        IconThemeData(
          color: Colors.white,
        ),
      buttonTheme:
        ButtonThemeData(
          buttonColor: Color.fromARGB( 255, 49, 182, 235 ),
          textTheme: ButtonTextTheme.accent,
        )
    );

  ThemeData lightTheme =
    ThemeData(
      accentColor: Colors.white,
      primaryColor: Color.fromARGB( 255, 49, 182, 235 ),
      primaryTextTheme: 
        TextTheme(
          title: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ), )
        ),
      appBarTheme: 
        AppBarTheme(
          color: Colors.white,
          textTheme:
            TextTheme(
              body1: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ), )
            ),
        ),
      primaryIconTheme:
        IconThemeData(
          color: Colors.blueGrey,
        ),
      accentIconTheme:
        IconThemeData(
          color: Colors.grey,
        ),
      buttonTheme:
        ButtonThemeData(
          buttonColor: Color.fromARGB( 255, 49, 182, 235 ),
          textTheme: ButtonTextTheme.accent,
        )
    );
    
class ThemeChanger with ChangeNotifier {

  ThemeData _themeData;
  
  ThemeChanger( this._themeData );

  getTheme() => _themeData;

  setTheme( ThemeData theme ) {
    _themeData = theme;
    notifyListeners();
  }

  setLightTheme() {
    _themeData = lightTheme;
    notifyListeners();
  }

  setDarkTheme() {
    _themeData = darkTheme;
    notifyListeners();
  }
}