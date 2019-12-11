import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:scene_alert/globals.dart' as globals;

class LocationSelect extends StatefulWidget {
  
  final locationData;
  LocationSelect({Key key, @required this.locationData}) : super(key: key);

  @override
  State<LocationSelect> createState() => LocationSelectState( locationData );
}

class LocationSelectState extends State<LocationSelect> {

  var locationData;
  LocationSelectState(this.locationData);

  GoogleMapController _controller;
  Set<Marker> myMarkers = {};

  static final CameraPosition curLocation = CameraPosition(
    target: LatLng( globals.lat, globals.lon ),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    myMarkers.add(
      Marker(
        markerId: MarkerId("My Id"),
        draggable: true,
        position: LatLng( globals.lat, globals.lon ),

        onTap: () {
          print( "Tapped" );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
          centerTitle: true,
          title: Text( "Select Location" ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Controls back button on AppBar
              Navigator.pop(context, true);
            }),
        ),
      body:
        Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,  // Flat image
              mapToolbarEnabled: false,
              markers: myMarkers,
              initialCameraPosition: curLocation,
              onCameraMove: ( (_position ) {
                updatePosition(_position);
              }),
              onMapCreated: mapCreated, // Calls when map is finished creating
            ),
            Positioned(
              bottom: 50,
              right: 10,
              child: 
                FloatingActionButton(
                    backgroundColor: Theme.of(context).accentColor,
                    child: new Icon(Icons.check, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        globals.tmpLat = globals.lat;
                        globals.tmpLon = globals.lon;
                      });
                      Navigator.pop(context, true);
                    },
                  ),
            ),
          ],
        )
    );
  }

  void mapCreated( controller ) {
    setState(() {
      _controller = controller;
    });
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print( "Get Location-----------" );
    print( position.latitude.toString() + " " + position.longitude.toString() );
    return position;
  }

  void updatePosition( position ) {
    Marker marker = myMarkers.firstWhere(
      (p) => p.markerId == MarkerId('My Id'),
      orElse: () => null
    );

    myMarkers.remove(marker);

    myMarkers.add(
      Marker(
        markerId: MarkerId("My Id"),
        draggable: true,
        position: LatLng( position.target.latitude, position.target.longitude ),
        onTap: () {
          print( "Tapped New" );
        }
      )
    );

    setState(() {
      globals.tmpLat = position.target.latitude;
      globals.tmpLon = position.target.longitude;
    });
  }

}