import 'package:flutter/material.dart';

class CrimeHistory extends StatefulWidget {
  @override
  State<CrimeHistory> createState() => CrimeHistoryState();
}

class CrimeHistoryState extends State<CrimeHistory> {

  String dropdownValue = '1 Day';
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 10,
          right: 10,
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Color.fromARGB( 255, 49, 182, 235 ),
            ),
            underline: Container(
              height: 2,
              color: Color.fromARGB( 255, 49, 182, 235 ),
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>[ '1 Day', '7 Days', '1 Month', '3 Months', '6 Months', '12 Months']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
          ),
        ),
        Center(
          child:
            Text("History will go here")
        )
      ],
    );
  }
}