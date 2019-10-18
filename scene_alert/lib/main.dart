import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scene_alert/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
     
  State<StatefulWidget> createState() {
    return MyAppState();
  }
 
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    CrimeMap(),
    Text('adsf 1'),
    Text('Work 2'),

    
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scene Alert',
      home: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text('Scene Alert'),
      ),
      body: 
      
      IndexedStack(
    index: _selectedPage,
    children: _pageOptions,
  ),
      
      //  _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar( 
        currentIndex: _selectedPage,
        onTap: (int index){
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            title: Text('Work')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            title: Text('Landscape')
          )

        ],
      
      
      ),

      )  
    );
  }
}

