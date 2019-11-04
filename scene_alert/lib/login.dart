import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scene_alert/landing.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {

  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
        Scaffold(
          body:
            Form(
              key: _formkey,
              child:
                Container(
                  padding: new EdgeInsets.all(25.0),
                  child:
                    Column(
                      children: <Widget>[
                        SizedBox(height: 50),
                        Image.asset(
                          'images/blue_foreground.png',
                          height: 200,
                          width: 200,
                        ),
                        SizedBox(height: 50),
                        TextFormField(
                          decoration: new InputDecoration(
                            helperText: "Email", 
                            focusedBorder:UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                            ),
                          ),
                          cursorColor: Colors.black,
                          onSaved: (input) {
                            setState(() {
                              _email = input;
                            });
                          }
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            helperText: "Password", 
                            focusedBorder:UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                            ),
                          ),
                          cursorColor: Colors.black,
                          obscureText: true,
                          onSaved: (input) => _password = input,
                        ),
                        SizedBox(height: 20),
                        Builder( builder: (context) =>
                          MaterialButton(
                            onPressed: () { 
                              validate( context );
                            },
                            elevation: 5,
                            minWidth: 200,
                            color: Color.fromARGB( 255, 49, 182, 235 ),
                            //Labels the button with Submit
                            child: Text('Login'),
                          ),
                        ),
                      ],
                    )
                )
            )
        ),
    );
  }

  Future validate( context ) async {
    _formkey.currentState.save();

    var url = 'https://scene-alert.com/inc/login.php?user=' + _email + '&pass=' + _password;
    print( url );
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if( data[0] == 1 ) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    }
    else if( data[0] == -1 ) {
      print( "Incorrect Login" );
    }

  }
}