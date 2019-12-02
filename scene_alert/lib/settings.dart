import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        // Write some code to control things, when user press Back navigation button in device navigationBar
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
                  )
                ],
              )
          )
        )
    );
  }

  Future storeMode() async {
    await storage.write(key: "darkMode", value: globals.darkMode.toString() );
  }
}