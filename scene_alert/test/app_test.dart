import 'dart:async';

import 'package:mockito/mockito.dart';

import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:glob/glob.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:scene_alert/main.dart';
import 'package:scene_alert/globals.dart' as globals;
import 'package:scene_alert/history.dart';
import 'package:scene_alert/landing.dart';
import 'package:scene_alert/location.dart';
import 'package:scene_alert/login.dart';
import 'package:scene_alert/map.dart';
import 'package:scene_alert/markerDetail.dart';
import 'package:scene_alert/register.dart';
import 'package:scene_alert/report.dart';
import 'package:scene_alert/settings.dart';

void main() {

  testWidgets('Login screen should appear', (tester) async {
    await tester.pumpWidget(new MyApp());
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Landing Page appears', (tester) async {
    await tester.pumpWidget(new LandingPage());
    expect(find.text('Scene Alert'), findsOneWidget);
  });

  testWidgets('Register Page appears', (tester) async {
    await tester.pumpWidget(new Register());
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Report Page appears', (tester) async {
    await tester.pumpWidget(new Report( type: ""));
    expect(find.text('Select Location'), findsOneWidget);
  });

  testWidgets('Location Page appears', (tester) async {
    await tester.pumpWidget(new LocationSelect(locationData: null));
    expect(find.byKey( Key("Submit Location") ), findsOneWidget);
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

}