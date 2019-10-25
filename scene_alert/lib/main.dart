import 'package:flutter/material.dart';
import 'package:scene_alert/landing.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }

  /*
    Login page will go here. 
    Having trouble getting textfields to render,
    waiting on backend database atm anyway
  */

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Column(
          children: <Widget>[
            Text("Testing"),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address'
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password'
              ),
            )
          ],
        ),
    );
  }
  */
}