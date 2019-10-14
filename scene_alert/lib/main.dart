import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scene Alert',
      home: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text('Scene Alert'),
      ),
      body: CrimeMap()

      )  
    );
  }
}

