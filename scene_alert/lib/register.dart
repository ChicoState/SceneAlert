import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {

  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                              onSaved: (input) {
                                setState(() {
                                  _email = input;
                                });
                              }
                            ),
                            TextFormField(
                              focusNode: fnPassword,
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
                              onSaved: (input) => _password = input,
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
                                //Labels the button with Submit
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
    return;
  }

}