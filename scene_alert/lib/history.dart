import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
              getHistory( newValue );
            },
            items: <String>[ '1 Day', '1 Week', '1 Month', '3 Months', '6 Months', '1 Year']
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
            FutureBuilder(
              future: getHistory(dropdownValue),
              builder: (BuildContext context, AsyncSnapshot snapshot ) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index][0]),
                    );
                  },
                );
              },
            )
        )
      ],
    );
  }

  Future getHistory( String timeRange ) async {
    print( "----------------------------------\nGetting history\n----------------------------------");
    timeRange = timeRange.replaceAll(new RegExp(r"\s|s"), "").toLowerCase();
    var url = 'https://scene-alert.com/inc/gethistory.php?range=' + timeRange;
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if( data[0] == 0 ) {
      var json = jsonDecode(data[1]);
      
      return json;
    }
    else {
      print( "Error" );
      return new List<List>(0);
    }
  }
}