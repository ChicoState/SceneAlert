import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: Scaffold(
      body: FireMap(),
      )
    );
  }
}

class FireMap extends StatefulWidget{
  State createState()=> FireMapState();
}

class FireMapState extends State<FireMap>{
  build(context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.142, -110.321),
          zoom: 15
        ),
      )

    ]);
  }
}

