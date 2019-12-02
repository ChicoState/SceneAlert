import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
//import 'package:android_intent/android_intent.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/landing.dart';
import 'package:scene_alert/login.dart';
import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/theme.dart';
import 'package:scene_alert/theme.dart' as themes;

bool validCreds = false;

void main() async {
   validCreds = await rememberValidate();
  // final pos = await getLocation();

 // globals.lat = pos.latitude;
 // globals.lon = pos.longitude;

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
      builder: (_) {
        if( globals.darkMode ) {
          return ThemeChanger( themes.darkTheme );
        }
        else {
          return ThemeChanger( themes.lightTheme );
        }
      },
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

Future getLocation() async {
  /* Enum
    Denied 0
    Disabled 1
    Granted 2
    Restricted 3
    Unknown 4
  */
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  GeolocationStatus geolocationStatus = await geolocator.checkGeolocationPermissionStatus();

  print( "Checking Location------------------------------------------");
  print( geolocationStatus.value );
  Position position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  /*
  Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
  if( !(position ?? false) ) {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  */

  globals.lat = position.latitude;
  globals.lon = position.longitude;

  return position;
}

Future rememberValidate() async {

  final storage = new FlutterSecureStorage();

  var _user, _pass;

  try {
    Map<String, String> userPass = await storage.readAll();
    print( "Reading keystore-----------------------------------------------------------" );
    print( userPass );
    _user = userPass.keys.last;
    _pass = userPass.values.last;
    bool darkmode = userPass.values.first == 'true';
    globals.darkMode = darkmode;
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