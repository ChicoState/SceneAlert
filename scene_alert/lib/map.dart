import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/markerDetail.dart';
import 'package:scene_alert/report.dart';
import 'package:scene_alert/sceneAlertIcons.dart';

GoogleMap _map;

class CrimeMap extends StatefulWidget {
  
  @override
  State<CrimeMap> createState() => CrimeMapState();
}

class CrimeMapState extends State<CrimeMap> with TickerProviderStateMixin {

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

    _aniController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

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

  AnimationController _aniController;
  static const List<IconData> icons = const [ SceneAlert.policemarker, SceneAlert.firemarker, SceneAlert.medicalmarker ];

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
        // Radius Slider
        Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child:
            Padding(
              padding: EdgeInsets.all(20.0),
              child:
                Container(
                  decoration: 
                    BoxDecoration( 
                      borderRadius: BorderRadius.circular(20.0), 
                      color: Color.fromARGB( 200, 255, 255, 255 ),
                    ),
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
                ),
            ),
        ),
        // Report button
        Positioned(
          bottom: 80,
          right: 10,
          child: 
            Column(
              mainAxisSize: MainAxisSize.min,
              children: new List.generate(icons.length, (int index) {
                Widget child = new Container(
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: new ScaleTransition(
                    scale: new CurvedAnimation(
                      parent: _aniController,
                      curve: new Interval(
                        0.0,
                        1.0 - index / icons.length / 2.0,
                        curve: Curves.easeOut
                      ),
                    ),
                    child: new FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Theme.of(context).accentColor,
                      mini: true,
                      child: new Icon(icons[index], color: Theme.of(context).primaryColor),
                      onPressed: () {
                        // Action for each button
                        print( index );
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return Report( type: index );
                        }));
                      },
                    ),
                  ),
                );
                return child;
              }).toList()..add(
                new FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Theme.of(context).accentColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  child: new AnimatedBuilder(
                    animation: _aniController,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.rotationZ(_aniController.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: new Icon(_aniController.isDismissed ? Icons.add : Icons.close),
                      );
                    },
                  ),
                  onPressed: () {
                    if (_aniController.isDismissed) {
                      _aniController.forward();
                    } else {
                      _aniController.reverse();
                    }
                  },
                ),
              ),
            ),
        ),
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
    print(url);
    var data = jsonDecode(response.body);
   
    BitmapDescriptor marker;
     print(data);
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
              icon: marker,
              onTap: () {
                print(json);
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