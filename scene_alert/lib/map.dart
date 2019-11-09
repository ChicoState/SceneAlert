import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:scene_alert/markerDetail.dart';
import 'package:scene_alert/globals.dart' as globals;

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

  /*
    Overrides the initial state so data is loaded before the map is
  */
  @override
  void initState() {
    super.initState();

    getCHP( 3 );

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'images/police128.png')
        .then(( value ) {
          setState(() {
            markerIcon = value;
          });
        });

  }

  // Store markers in a set to be later passed to GoogleMap()
  Set<Marker> myMarkers = {};
  GoogleMapController _controller;
  // Placeholder for dynamic icons
  BitmapDescriptor markerIcon;

  double radius = 0;
  List<int> rangeOptions = [ 3, 5, 10, 15, 20, 30, 50, 100 ];

  // Beginning of the rendering code
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,  // Flat image
          initialCameraPosition: chico,
          markers: myMarkers,
          onMapCreated: mapCreated, // Calls when map is finished creating
        ),
        Positioned(
          child:
            Slider(
              activeColor: Theme.of(context).primaryColor,
              min: 0,
              max: 7,
              label: rangeOptions[radius.ceil()].toString(),
              divisions: 7,
              value: radius,
              onChanged: (newVal) {
                setState(() {
                  radius = newVal;
                  //print( radius.toString() + "|" + rangeOptions[radius.ceil()].toString() );
                });
              },
              onChangeEnd: (newVal) {
                getCHP( rangeOptions[newVal.ceil()] );
                globals.radius = rangeOptions[newVal.ceil()];
              },
            ),
          bottom: 5,
          width: MediaQuery.of(context).size.width,
        )
      ],
    );
  }

  /*
    Pulls CHP data from the server
    Transforms response to JSON
    Makes a marker and adds it to Set
  */
  Future getCHP( radius ) async {
    var url = 'https://scene-alert.com/inc/getincidents.php?lat=39.7250751&lon=-121.8367999&radius=' + radius.toString();
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if( data[0] == 0 ) {
      var json = jsonDecode(data[1]);
      for( var i = 0; i < json.length; i++ ) {
        try {
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
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return MarkerDetail( myjson: json[i]);
                }));
              },
            )
          );
        }
        catch (error) {
          print( error );
        }
      }
      setState(() {
        myMarkers = myMarkers;
      });
    }
    else {
      // HTTP get Failed
      print( "Error" );
    }
  }

  void mapCreated( controller ) {
    setState(() {
      _controller = controller;
    });
  }
}