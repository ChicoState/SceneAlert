import 'package:flutter/material.dart';

class Report extends StatefulWidget {

  var type;
  Report({Key key, @required this.type}) : super(key: key);
  
  @override
  State<Report> createState() => ReportState( type );
}

class ReportState extends State<Report>  {

  var type;
  ReportState(this.type);

  var reportTypes = { 0:"Crime", 1:"Fire", 2:"Medical" };

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                Container(
                  padding: new EdgeInsets.all(25.0),
                  child:
                    Column(
                      children: <Widget>[
                        Text( "Title" ),
                        TextFormField(
                          //focusNode: fnEmail,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (term) {
                            //fnEmail.unfocus();
                            //FocusScope.of(context).requestFocus(fnPassword);
                          },
                          decoration: new InputDecoration(
                            //helperText: "Title", 
                            border: OutlineInputBorder(),
                          ),
                          cursorColor: Colors.black,
                          onSaved: (input) => _title = input,
                        ),
                        SizedBox( height: 20 ),
                        Text( "Description" ),
                        TextFormField(
                          //focusNode: fnPassword,
                          decoration: InputDecoration(
                            //contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            //rhelperText: "Description",
                          ),
                          cursorColor: Colors.black,
                          obscureText: true,
                          onSaved: (input) => _description = input,
                        ),
                        SizedBox( height: 50 ),
                        Builder( builder: (context) =>
                          MaterialButton(
                            onPressed: () { 
                              submitReport( context );
                            },
                            elevation: 5,
                            minWidth: 200,
                            color: Color.fromARGB( 255, 49, 182, 235 ),
                            //Labels the button with Submit
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    )
                    )
            )
        )
    );
  }

  Future submitReport( context ) async {
    _formkey.currentState.save();

    print( _title );
    print( _description );
  }
}