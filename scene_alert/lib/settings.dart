import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/theme.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // Controls back button on device
        Navigator.pop(context, true);
      },
      child:
        Scaffold(
          appBar:
            AppBar(
              centerTitle: true,
              title: Text('Scene Alert'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            ),
          body:
          Center(
            child:
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Text( "Dark Mode" ),
                  Switch(
                    value: globals.darkMode,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: ( value ) {
                      setState(() {
                        globals.darkMode = value;

                        if( globals.darkMode ) {
                          Provider.of<ThemeChanger>(context).setTheme( ThemeData.dark() );
                        }
                        else {
                          Provider.of<ThemeChanger>(context).setLightTheme();
                        }
                      });
                      storeMode();
                    },
                  ),
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
                  ),
                ],
              )
          )
        )
    );
  }

  Future storeMode() async {
    await storage.write(key: "darkMode", value: globals.darkMode.toString() );
  }

  Future deleteVal() async {
    await storage.deleteAll();
  }
}