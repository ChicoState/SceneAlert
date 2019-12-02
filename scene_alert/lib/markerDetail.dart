import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scene_alert/globals.dart' as globals;
import 'package:http/http.dart' as http;

class MarkerDetail extends StatefulWidget {
  var myjson;
  

  MarkerDetail({Key key, @required this.myjson}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MarkerState(myjson);
  }
}

class MarkerState extends State<MarkerDetail> {
  String appBarTitle;
  Marker marker;
  var myjson;
  MarkerState(this.myjson);

  @override
  Widget build( BuildContext context ) {
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("View Event"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //event title
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    myjson[0].toString(),
                    style: TextStyle(fontSize: 18.0),
                    ),
                ),
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
                            addComment();
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {}

  // Convert int priority to String priority and display it to user in DropDown

  void addComment() async {
    print(globals.loggedUserId);
      print(globals.loggedUserNam);
      if(globals.loggedUserId == -1){
        globals.loggedUserId = 100;
      }
    // timeRange = timeRange.replaceAll(new RegExp(r"\s|s"), "").toLowerCase();
    // var url = 'https://scene-alert.com/inc/addComment.php?incident=' + "..." + '&parent=' + '...' + '&user=' + '&comment' + '...';
    // print( url );
    // http.Response response = await http.post(url);
  }


}
