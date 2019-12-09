import 'package:flutter/material.dart';

class Report extends StatefulWidget {

  final type;
  Report({Key key, @required this.type}) : super(key: key);
  
  @override
  State<Report> createState() => ReportState( type );
}

class ReportState extends State<Report>  {

  var type;
  ReportState(this.type);

  var reportTypes = { 0:"Crime", 1:"Fire", 2:"Medical" };

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FocusNode fnTitle = FocusNode();
  final FocusNode fnDesc = FocusNode();

  String _title, _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppBar(
          centerTitle: true,
          title: Text( reportTypes[type].toString() + " Report"),
          leading: 
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              }
            ),
        ),
      body:
        SingleChildScrollView(
          child:
            Form(
              key: _formkey,
              child:
                Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.fromLTRB(10.0,20.0,10.0,0.0),
                      child:
                        Column(
                          children: <Widget>[
                            TextFormField(
                              focusNode: fnTitle,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                fnTitle.unfocus();
                                FocusScope.of(context).requestFocus(fnDesc);
                              },
                              decoration: new InputDecoration(
                                hintText: "Title",
                              ),
                              cursorColor: Colors.black,
                              onSaved: (input) => _title = input,
                            ),
                            SizedBox( height: 20 ),
                            TextFormField(
                              focusNode: fnDesc,
                              minLines: 5,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintMaxLines: 20,
                                hintText: "Description of the incident",
                              ),
                              cursorColor: Colors.black,
                              obscureText: true,
                              onSaved: (input) => _description = input,
                            ),
                          ],
                        )
                    ),
                    SizedBox( height: 20 ),
                    Divider(
                      thickness: 2.0,
                    ),
                    // Location Selection
                    Builder( builder: (context) =>
                      MaterialButton(
                        onPressed: () { 
                          selectLocation( context );
                        },
                        elevation: 5,
                        minWidth: 200,
                        color: Colors.grey[0],
                        child:
                          Row(
                            children: <Widget>[
                              Icon( Icons.location_on, color: Colors.grey[600] ),
                              Text( "Select Location", style: TextStyle( color: Colors.grey[600] ) ),
                            ],
                          )
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                    Builder( builder: (context) =>
                      MaterialButton(
                        onPressed: () { 
                          selectPhoto( context );
                        },
                        elevation: 5,
                        minWidth: 200,
                        color: Colors.grey[0],
                        child:
                          Row(
                            children: <Widget>[
                              Icon( Icons.camera_enhance, color: Colors.grey[600] ),
                              Text( "Add Photo or Video", style: TextStyle( color: Colors.grey[600] ) ),
                            ],
                          )
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                    SizedBox( height: 20 ),
                    Builder( builder: (context) =>
                      MaterialButton(
                        onPressed: () { 
                          submitReport( context );
                        },
                        elevation: 5,
                        minWidth: 200,
                        color: Color.fromARGB( 255, 49, 182, 235 ),
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
            ),
        )
    );
  }

  Future submitReport( context ) async {
    _formkey.currentState.save();

    print( _title );
    print( _description );
  }

  Future selectLocation( context ) async {
    print( "LocationPressed" );
  }

  Future selectPhoto( context ) async {
    print( "PhotoPressed" );
  }
}