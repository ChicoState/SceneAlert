//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scene_alert/landing.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {

  String _email, _password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FocusNode fnEmail = FocusNode();
  final FocusNode fnPassword = FocusNode();

  final storage = new FlutterSecureStorage();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();

    //deleteVal();
    //rememberValidate( context );
  }

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                  value: rememberMe,
                                  checkColor: Colors.white,
                                  activeColor: Color.fromARGB( 255, 49, 182, 235 ),
                                  onChanged: (bool remember) {
                                    setState(() {
                                      rememberMe = remember;
                                    });
                                  },
                                ),
                                Text( "Remember Me" )
                              ],
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
                            Builder( builder: (context) =>
                              MaterialButton(
                                onPressed: () { 
                                  rememberValidate( context );
                                },
                                elevation: 5,
                                minWidth: 200,
                                color: Color.fromARGB( 255, 49, 182, 235 ),
                                //Labels the button with Submit
                                child: Text('Restore Session'),
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

  Future validate( context ) async {
    _formkey.currentState.save();

    var url = 'https://scene-alert.com/inc/login.php?user=' + _email + '&pass=' + _password;
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if( rememberMe ) {
      await storage.write(key: _email, value: _password);
    }

    if( data[0] == 1 ) {
      if( rememberMe ) {
        await storage.write(key: _email, value: _password);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    }
    else if( data[0] == -1 ) {
      print( "Incorrect Login" );
    }

  }

  Future rememberValidate( context ) async {

    var _user, _pass;

    try {
      Map<String, String> userPass = await storage.readAll();
      _user = userPass.keys.first;
      _pass = userPass.values.first;
    }
    catch (error) {
      print( "Keystore error, returning to login" );
      return;
    }

    var url = 'https://scene-alert.com/inc/login.php?user=' + _user + '&pass=' + _pass;
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

  Future deleteVal() async {
    await storage.deleteAll();
  }

}