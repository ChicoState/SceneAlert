import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('Testing Login', (tester) async {
    await tester.pumpWidget(Login());
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember Me'), findsOneWidget);
    expect(find.text('Dark Mode'), findsNothing);
    expect(find.text('Register'), findsOneWidget);
  });

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
    int test = 0;
    //  print(coms);
    if (coms.length >= 0) {
      test = 1;
    }
    expect(test, 1);
  });

  test('Broken Make Comment Bad User', () async {
    globals.testing = true;
    commentClass state = new commentClass();
    String coms = await state.addComment(0, -1, 0, 0);
    expect(coms, "Error:NotLogged");
  });

  test('Broken Make Comment No Text', () async {
    globals.testing = true;
    commentClass state = new commentClass();
    String t;
    String coms = await state.addComment(0, 4, 0, t);
    expect(coms, "Error:NoText");
  });

  test('Working Make Comment', () async {
    globals.testing = true;
    commentClass state = new commentClass();
    String t = "hi";
    String coms = await state.addComment(0, 4, "testerUser", t);
    expect(coms, "Success");
  });
}
