import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
            title: Text("View Event", style: TextStyle( color: Color.fromARGB( 255, 49, 182, 235 ) )),
            backgroundColor: Color.fromARGB( 255, 255, 255, 255 ),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color.fromARGB( 255, 49, 182, 235 ) ),
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
                        // color: Colors.grey,
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
                          color: Color.fromARGB( 255, 49, 182, 235 ),
                          textColor: Colors.white,
                          child: Text(
                            'Comment',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Color.fromARGB( 255, 49, 182, 235 ),
                          textColor: Colors.white,
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

}
