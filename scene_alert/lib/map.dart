import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CrimeMap extends StatefulWidget {
  @override
  State<CrimeMap> createState() => CrimeMapState();
}

class CrimeMapState extends State<CrimeMap> {

  /*
    Setting initial position
    Will be Chico until present location data is used
  */
  static final CameraPosition chico = CameraPosition(
    target: LatLng( 39.7250751,-121.8367999 ),
    zoom: 9,
  );

  // Store markers in a set to be later passed to GoogleMap()
  Set<Marker> myMarkers = {};
  GoogleMapController _controller;
  // Placeholder for dynamic icons
  BitmapDescriptor markerIcon;

  // Beginning of the rendering code
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Scene Alert'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,  // Flat image
        initialCameraPosition: chico,
        markers: myMarkers,
        onMapCreated: mapCreated, // Calls when map is finished creating
      ),
    );
  }

  /*
    Pulls CHP data from the server
    Transforms response to JSON
    Makes a marker and adds it to Set
  */
  Future getCHP() async {
    var url = 'http://rhapidfyre.com/scenealert/scripts/getincidents.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if( data[0] == 0 ) {
      var json = jsonDecode(data[1]);
      for( var i = 0; i < json.length - 1; i++ ) {
        myMarkers.add(
          Marker(
            markerId: MarkerId( i.toString() ),
            position: LatLng( double.parse(json[i][4]), double.parse(json[i][3]) ),
            infoWindow: InfoWindow(
              title: json[i][0],  // Incident Report name
              snippet: json[i][2],  // Reported by what agency
            ),
            icon: markerIcon,
            onTap: () {
              /*
                TODO
                Implement a function to open a new page with full information about an incident
                Mostly likely to come after user input
              */
              handleTap(json[i][0]);
            },
          )
        );
      }
    }
    else {
      // HTTP get Failed
      print( "Error" );
    }
  }

  /*
    TODO
    See marker onTap()
  */
  void handleTap(String title) {
    print( title );
  }

  /*
    Overrides the initial state so data is loaded before the map is
  */
  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'images/police128.png')
        .then(( value ) {
          setState(() {
            markerIcon = value;
          });
        });

    getCHP();
  }

  void mapCreated( controller ) {
    setState(() {
      _controller = controller;
    });
  }
}