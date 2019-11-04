import 'package:flutter/material.dart';
import 'package:scene_alert/landing.dart';
import 'package:scene_alert/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Login();
  }
}