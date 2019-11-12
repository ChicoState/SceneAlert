import 'package:flutter/material.dart';

double lat = 39.7250751;
double lon = -121.8367999;
int radius = 3;
bool darkMode = false;

ThemeData darkTheme = 
  ThemeData(
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

ThemeData theme = lightTheme;