import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    target: LatLng( globals.lat, globals.lon ),
    zoom: 11,
  );

  String _mapStyle;

  /*
    Overrides the initial state so data is loaded before the map is
  */
  @override
  void initState() {
    super.initState();

    getCHP( 3 );

    rootBundle.loadString('assets/dark.json').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'images/policeMarker128.png')
        .then(( value ) {
          setState(() {
            policeMarkerIcon = value;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'images/fireMarker128.png')
        .then(( value ) {
          setState(() {
            fireMarkerIcon = value;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'images/multiMarker128.png')
        .then(( value ) {
          setState(() {
            multiMarkerIcon = value;
          });
        });

  }

  // Store markers in a set to be later passed to GoogleMap()
  Set<Marker> myMarkers = {};
  GoogleMapController _controller;
  // Placeholder for dynamic icons
  BitmapDescriptor policeMarkerIcon;
  BitmapDescriptor fireMarkerIcon;
  BitmapDescriptor multiMarkerIcon;


  double radius = 0;
  List<int> rangeOptions = [ 3, 5, 10, 15, 20, 30, 50, 100 ];

  // Beginning of the rendering code
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,  // Flat image
          mapToolbarEnabled: false,
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
    var url = 'https://scene-alert.com/inc/getincidents.php?' + 
      'lat=' + globals.lat.toString() + '&lon=' + globals.lon.toString() +'&radius=' + radius.toString();
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    BitmapDescriptor marker;

    if( data[0] == 0 ) {
      var json = jsonDecode(data[1]);
      for( var i = 0; i < json.length; i++ ) {
        try {
          if( json[i][1] == "2" ) {
            marker = fireMarkerIcon;
          }
          else if( json[i][1] == "4" ) {
            marker = multiMarkerIcon;
          }
          else {
            marker = policeMarkerIcon;
          }
          myMarkers.add(
            Marker(
              markerId: MarkerId( i.toString() ),
              position: LatLng( double.parse(json[i][4]), double.parse(json[i][3]) ),
              infoWindow: InfoWindow(
                title: json[i][0],  // Incident Report name
                snippet: json[i][2],  // Reported by what agency
              ),
              icon: marker,
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

      if( globals.darkMode ) {
        controller.setMapStyle( _mapStyle );
      }
      else {
        controller.setMapStyle( "[]" );
      }
    });
  }
}