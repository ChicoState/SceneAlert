import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/globals.dart' as globals;


class MarkerDetail extends StatefulWidget {
  final myjson;
  
  MarkerDetail({Key key, @required this.myjson}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print(myjson);
    return MarkerState(myjson);
  }
}

  class myComment{
    final int id;
    final String user;
    final String text;

    myComment(this.id , this.user, this.text);
  }

class MarkerState extends State<MarkerDetail> {
  String appBarTitle;
  Marker marker;
  commentClass tt;
  var myjson;
  MarkerState(this.myjson);
  final userCommentString = TextEditingController();

  //   Future<List<myComment>> commentList;

  @override
  void initState() {
    super.initState();
    tt = new commentClass();
  }
  


  @override
  Widget build( BuildContext context ) {
    return WillPopScope(
        onWillPop: () {
          // Controls back button on device
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            //title: Text("View Event"),
            title: Text( myjson[0].toString() ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Controls back button on AppBar
                  moveToLastScreen();
                }),
          ),
          body:
            Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //Image
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Image(
                    image: AssetImage('images/404_image.png'),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  // child: Container(
                  child: Text("Description: "),
                ),
                //Description
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  // child: Container(
                  child: Text(myjson[2].toString()),
                ),
                //comment text field
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 3,
                        controller: userCommentString,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter your text here"),
                      ),
                    ))),
                //Buttons (comment/follow)
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'Comment',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            // print(userCommentString.text.toString());
                           tt.addComment(myjson[5], globals.loggedUserId, globals.loggedUserNam, userCommentString.text.toString()) ;
                             userCommentString.clear();
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text(
                            'Follow',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Follow button clicked");
                            });
                          },
                        ),
                      )
                    
                    ],
                  ),
                ),
              commentWidget()],
            ),
          ),
        ),
    );
  }

Widget commentWidget() {

    return    FutureBuilder(
              future: tt.getComments(myjson[5]),
              builder: (BuildContext context, AsyncSnapshot snapshot ) {
                if(snapshot.data == null){
                   return Center( child: Text("Loading"));
                }
                  if(snapshot.data.length == 0){
                    return Center( child: Text("No Comments"));
                  }
                  return ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                              leading:    Icon(Icons.account_circle,size: 30.0,),
                              title: Text(snapshot.data[index].text + ""),
                              subtitle: Text(snapshot.data[index].user + ""),
                              trailing: Icon(Icons.more_vert),

                    );
                  },
                );
              }
            );
}



  void moveToLastScreen() {
    // Moves back the original page
    Navigator.pop(context, true);
  }
}

class commentClass{
    Future<List<myComment>> getComments(var curId) async {
    var url = 'https://scene-alert.com/inc/getComment.php?incident=' + curId.toString();
    http.Response response = await http.get(url);
    var data;
  print(curId);
     try { 
      data = jsonDecode(response.body);
    } on Exception catch (_) {
        return new List<myComment>(0);
    }
    //for some reason jsonDecode was not working when trying to access the fields in the comments array so I had to use regex
    //not ideal but works for the show case 

     if( data[0] == 1 ) {
       var myJ = jsonDecode(data[1]);
      List<myComment> coms = [];
      for(var u in myJ){
        // print(u);
        // print(u[0] + " " + u[1] + " " + u[2]);
        // RegExp exp = new RegExp(r"\[([0-9]+), ([a-z0-9A-Z]+), ([a-z0-9A-Z\]\.\+\?\! \-]+)]");
        // var match = exp.firstMatch(u.toString());
        
        myComment c = myComment(int.parse(u[0]) , u[1].toString() , u[2].toString());
        coms.add(c);
      }
      return coms;
    }
    else {
      print( "Error" );
      return new List<myComment>(0);
    }
  }

    Future<String> addComment(var incidentId, var userId, var userNam, var userText) async {
    var url;
          
      if(userId == -1){
        return "Error:NotLogged";
      }
    //  userCommentString.clear();
    //userCommentString.text
    // timeRange = timeRange.replaceAll(new RegExp(r"\s|s"), "").toLowerCase();
    if(userText != null){
     url = 'https://scene-alert.com/inc/addComment.php?incident=' + incidentId.toString() + '&parent=null'  + '&userid='+ userId.toString()  + '&username=' + userNam.toString() + '&comment=' + userText.toString();
      http.Response response = await http.post(url);
      return "Success";
    }
    return "Error:NoText";
    
  }
}
