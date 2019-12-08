import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/markerDetail.dart';


class CrimeHistory extends StatefulWidget {
  @override
  State<CrimeHistory> createState() => CrimeHistoryState();
}

class CrimeHistoryState extends State<CrimeHistory> {

  String dropdownValue = '1 Day';

  Future<List> historyList;

  @override
  void initState() {
    super.initState();
    historyList = getHistory( "" );
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 45,
          child:
            FutureBuilder(
              future: historyList,
              builder: (BuildContext context, AsyncSnapshot snapshot ) {
                if ( !snapshot.hasData || snapshot.data.length == 0 ) {
                  return Center( child: Text("Please select a time range.") );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child:
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            backgroundImage: ( () {
                              if( snapshot.data[index][1] == "2" ) {
                                return AssetImage('images/fireMarker128.png');
                              }
                              else if( snapshot.data[index][1] == "4" ) {
                                return AssetImage('images/multiMarker128.png');
                              }
                              else {
                                return AssetImage('images/policeMarker128.png');
                              }
                            } () )
                          ),
                          title: Text( snapshot.data[index][3] + " " + snapshot.data[index][0] ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return MarkerDetail( myjson: snapshot.data[index] );
                            }));
                          },
                        ),
                    );
                  },
                );
              },
            ),
        ),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width/3,
          right: MediaQuery.of(context).size.width/3,
          child: 
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 2,
                color: Color.fromARGB( 255, 49, 182, 235 ),
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  historyList = getHistory( newValue );
                });
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
      ],
    );
  }

  Future<List> getHistory( String timeRange ) async {
    if( timeRange == "" ) {
      return new List<List>(0);
    }
    timeRange = timeRange.replaceAll(new RegExp(r"\s|s"), "").toLowerCase();
    var url = 'https://scene-alert.com/inc/gethistory.php?lat=' + 
      globals.lat.toString() + '&lon=' + globals.lon.toString() + '&radius=' + globals.radius.toString() + '&time=' + timeRange;
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