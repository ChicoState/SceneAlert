import 'package:flutter/material.dart';
import 'package:scene_alert/history.dart';
import 'package:scene_alert/map.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {

  int _selectedPage = 1;
  final _pageOptions = [
    Center( child: Text('Future Widget') ),
    CrimeMap(),
    CrimeHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scene Alert',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Scene Alert', style: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ) )),
          backgroundColor: Color.fromARGB( 255, 255, 255, 255 ),
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
              icon: Icon(Icons.map),
              title: Text('Map')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text('History')
            )

          ],
        ),
      )  
    );
  }
}