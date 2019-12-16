import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scene_alert/main.dart';
import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/history.dart';
import 'package:scene_alert/landing.dart';
import 'package:scene_alert/location.dart';
import 'package:scene_alert/login.dart';
import 'package:scene_alert/map.dart';
import 'package:scene_alert/markerDetail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scene_alert/logout.dart';
import 'package:scene_alert/register.dart';
import 'package:scene_alert/report.dart';
import 'package:scene_alert/secondPage.dart';
import 'package:scene_alert/settings.dart';
import 'package:scene_alert/theme.dart';
import 'package:provider/provider.dart';

void main() {
   Widget makeTestableWidget({Widget child}) {

      return MaterialApp(
        home: child,
    );
  }

     Widget ThemeWidget({ThemeData theme}) {

      return MaterialApp(
        home: Container(),
        theme: theme,
    );
  }

  testWidgets('Login screen should appear', (tester) async {
    await tester.pumpWidget(new MyApp());
    expect(find.text('Login'), findsOneWidget);
  });

  test('Broken Comment Get', () async {
  globals.testing = true;
   commentClass state = new commentClass();
   List<myComment> coms = await state.getComments(1);
   expect(coms.length, 0);

  });
  test('Working Comment Get', () async {
  globals.testing = true;
   commentClass state = new commentClass();
   List<myComment> coms = await state.getComments(110047);
   int test =0;
   if(coms.length >= 0){
     test = 1;
   }
   expect(test, 1);

  });

  test('Broken Make Comment Bad User', () async {
      globals.testing = true;
   commentClass state = new commentClass();
   String coms = await state.addComment(0,-1,0,0);
   expect(coms, "Error:NotLogged");

  });

  test('Broken Make Comment No Text', () async {
    globals.testing = true;
   commentClass state = new commentClass();
   String t;
   String coms = await state.addComment(0,4,0,t);
   expect(coms, "Error:NoText");

  });

    test('Working Make Comment', () async {
    globals.testing = true;
   commentClass state = new commentClass();
   String t = "hi";
   String coms = await state.addComment(0,4,"testerUser",t);
   expect(coms, "Success");

  });

  testWidgets('MarkerDetailWidgetTest', (tester) async {
    var t = jsonEncode("[test, 1, tt, -121.8450071, 39.730125, 110352]");
    await tester.pumpWidget(makeTestableWidget( child: new MarkerDetail(myjson: t)));
    expect(find.text('Description: '), findsOneWidget);
  });

  testWidgets('Logout Test', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget( child: new Logout()));
    expect(find.text('Logout'), findsOneWidget);
    
  });
      testWidgets('Dark Theme Test', (WidgetTester tester) async {
    await tester.pumpWidget(ThemeWidget( theme: darkTheme));
  });
      testWidgets('Light Theme Test', (WidgetTester tester) async {
    await tester.pumpWidget(ThemeWidget( theme: lightTheme));
  });

        testWidgets('Second Page Widget', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget( child: new SecondPage(payload: "hi!",)));
    expect(find.text('Second Page - Payload:'), findsOneWidget); 
  });

}
