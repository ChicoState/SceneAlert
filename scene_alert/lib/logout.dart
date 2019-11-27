import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scene_alert/globals.dart' as globals;

class Logout extends StatefulWidget {
  @override
  State<Logout> createState() => LogoutState();
}

class LogoutState extends State<Logout> {
  
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        MaterialButton(
          child: Text("Logout"),
          elevation: 5,
          minWidth: 200,
          color: Color.fromARGB( 255, 49, 182, 235 ),
          onPressed: () {
            deleteVal();
            print( "Logout:" );
            print( globals.radius );
          },
        ) 
    );
  }

  Future deleteVal() async {
    await storage.deleteAll();
  }
}