import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:scene_alert/login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {

  String _user, _email, _password, _password2;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FocusNode fnUser = FocusNode();
  final FocusNode fnEmail = FocusNode();
  final FocusNode fnPassword = FocusNode();
  final FocusNode fnPassword2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
        Scaffold(
          //resizeToAvoidBottomInset: false,
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
                            SizedBox(height: 50),
                            Image.asset(
                              'images/blue_foreground.png',
                              height: 200,
                              width: 200,
                            ),
                            SizedBox(height: 50),
                            TextFormField(
                              focusNode: fnUser,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                fnUser.unfocus();
                                FocusScope.of(context).requestFocus(fnEmail);
                              },
                              decoration: new InputDecoration(
                                helperText: "Username", 
                                focusedBorder:UnderlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                                ),
                              ),
                              cursorColor: Colors.black,
                              onSaved: (input) => _user = input,
                            ),
                            TextFormField(
                              focusNode: fnEmail,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                fnEmail.unfocus();
                                FocusScope.of(context).requestFocus(fnPassword);
                              },
                              decoration: new InputDecoration(
                                helperText: "Email", 
                                focusedBorder:UnderlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                                ),
                              ),
                              cursorColor: Colors.black,
                              onSaved: (input) => _email = input,
                            ),
                            TextFormField(
                              focusNode: fnPassword,
                              decoration: InputDecoration(
                                helperText: "Password",
                                focusedBorder:UnderlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                                ),
                              ),
                              onFieldSubmitted: (term) {
                                fnPassword.unfocus();
                                FocusScope.of(context).requestFocus(fnPassword2);
                              },
                              cursorColor: Colors.black,
                              obscureText: true,
                              onSaved: (input) => _password = input,
                            ),
                            TextFormField(
                              focusNode: fnPassword2,
                              decoration: InputDecoration(
                                helperText: "Confirm Password",
                                focusedBorder:UnderlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                                ),
                              ),
                              cursorColor: Colors.black,
                              obscureText: true,
                              onSaved: (input) => _password2 = input,
                            ),
                            SizedBox(height: 20),
                            Builder( builder: (context) =>
                              MaterialButton(
                                onPressed: () { 
                                  register( context );
                                },
                                elevation: 5,
                                minWidth: 200,
                                color: Color.fromARGB( 255, 49, 182, 235 ),
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        )
                    )
                )
            )
        ),
    );
  }

  Future register( context ) async {
    _formkey.currentState.save();

    print( _user );
    print( _email );
    print( _password );
    print( _password2 );

    if( _password == _password2 ) {
      var url = 'https://scene-alert.com/inc/register.php?user=' + _user + '&email=' + _email + '&pass=' + _password;
      http.Response response = await http.get(url);
      var data = jsonDecode(response.body);

      if( data[0] == 1 ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
      else if( data[0] == -1 ) {
        print( "Incorrect Login" );
      }
    }

  }

}