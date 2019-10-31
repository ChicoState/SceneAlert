import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scene_alert/landing.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
        Scaffold(
          body:
            Form(
              //key:
              child:
                Container(
                  padding: new EdgeInsets.all(25.0),
                  child:
                    Column(
                      children: <Widget>[
                        TextFormField(
                        decoration: new InputDecoration(
                          icon: Icon(Icons.email, color: Colors.black), 
                          helperText: "Email", 
                          focusedBorder:UnderlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                          ),
                        ),
                        cursorColor: Colors.black,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: Colors.black), 
                            helperText: "Password", 
                            focusedBorder:UnderlineInputBorder(
                            borderSide: const BorderSide(color: Color.fromARGB( 255, 49, 182, 235 ), width: 2.0),
                            ),
                          ),
                          cursorColor: Colors.black,
                          obscureText: true,
                        ),
                        MaterialButton(
                          onPressed: () { 
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (context) => Login()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          elevation: 5,
                          minWidth: 200,
                          color: Color.fromARGB( 255, 49, 182, 235 ),
                          //Labels the button with Submit
                          child: Text('Login'),
                        ),
                      ],
                    )
                )
            )
        ),
    );
  }
}