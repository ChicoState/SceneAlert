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
}
