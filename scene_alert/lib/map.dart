import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/login.dart';
import 'package:scene_alert/markerDetail.dart';

GoogleMap _map;



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
    zoom: 11,
  );

  // Store markers in a set to be later passed to GoogleMap()
  Set<Marker> myMarkers = {};
  GoogleMapController _controller;
  // Placeholder for dynamic icons
  BitmapDescriptor markerIcon;

  // Beginning of the rendering code
  @override
  Widget build(BuildContext context) {

    tmpMarkers();

    return _map = 
      GoogleMap(
        mapType: MapType.normal,  // Flat image
        initialCameraPosition: chico,
        markers: myMarkers,
        onMapCreated: mapCreated, // Calls when map is finished creating
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
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return MarkerDetail( myjson: json[i]);
              }));
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
//simulating the json from whats read in from the php request from above
  Future tmpMarkers() async {
    var jsonString = '''
    [
    [
      "Missing Dog",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque volutpat ultricies sem ac convallis. Sed ut viverra arcu. Nunc ullamcorper augue sit amet velit dignissim, at ultrices velit tincidunt.",
      "Joe Joe"
    ],
    [
      "House Break In at...",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque volutpat ultricies sem ac convallis. Sed ut viverra arcu.",
      "Marry Sue"
    ],
    [
      "Fire in tree",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque volutpat ultricies sem ac convallis. ",
      "Fire Department"
    ],
    [
      "Car Wreck At 423 Esplande",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque volutpat ultricies sem ac convallis.",
      "CHP"
    ]
  ]
''';

var tempJson = jsonDecode(jsonString);
  
    var tmpLocations = [
      [ 39.726421, -121.842728 ],
      [ 39.737559, -121.863048 ],
      [ 39.756677, -121.838937 ],
      [ 39.761417, -121.878801 ],
    ];
    
    for( var i = 0; i < tmpLocations.length; i++ ) {
      myMarkers.add(
        Marker(
          markerId: MarkerId( i.toString() ),
          position: LatLng( tmpLocations[i][0], tmpLocations[i][1] ),
          infoWindow: InfoWindow(
            title: tempJson[i][0].toString(),
            snippet: tempJson[i][2].toString(),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return MarkerDetail(myjson: tempJson[i]);
              }));
            }
          ),
          icon: markerIcon,
          onTap: () {
            handleTap( "Test " + tempJson[i][0] );
          },
        ),
      );
    }
  }

  /*
    TODO
    See marker onTap()
  */
  void handleTap(String title) {
        
    /*
    Going to use FutureBuilder here to pull more info from the database 
    for the particular incident that was tapped

    Future Builder will
      - Make query for specific incident information
      - Build widget on the side/bottom/whole page
      - Fill widget with more information
        - Pictures/videos, deeper description ( follow ups example from CHP ), comments
    */
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

    //getCHP();
  }

  void mapCreated( controller ) {
    setState(() {
      _controller = controller;
    });
  }
}