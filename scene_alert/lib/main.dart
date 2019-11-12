import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/landing.dart';
import 'package:scene_alert/login.dart';
import 'package:scene_alert/theme.dart';
import 'package:scene_alert/theme.dart' as themes;

bool validCreds = false;

void main() async {
  validCreds = await rememberValidate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger( themes.lightTheme ),
      child: new MyAppWithTheme(),
    );
  }
}

class MyAppWithTheme extends StatelessWidget {
  @override
  Widget build( BuildContext context ) {
    final theme = Provider.of<ThemeChanger>(context);
    //theme.setLightTheme();
    return MaterialApp(
      home: ( () { 
        return validCreds ? LandingPage() : Login();
      } () ),
      theme: theme.getTheme(),
    );
  }
}

Future rememberValidate() async {

  final storage = new FlutterSecureStorage();

  var _user, _pass;

  try {
    Map<String, String> userPass = await storage.readAll();
    _user = userPass.keys.first;
    _pass = userPass.values.first;
  }
  catch (error) {
    print( "No login in keystore" );
    return false;
  }

  var url = 'https://scene-alert.com/inc/login.php?user=' + _user + '&pass=' + _pass;
  http.Response response = await http.get(url);
  var data = jsonDecode(response.body);

  if( data[0] == 1 ) {
    return true;
  }
  else if( data[0] == -1 ) {
    print( "Incorrect Login" );
    return false;
  }

}