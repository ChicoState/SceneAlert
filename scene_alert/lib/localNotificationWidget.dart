import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scene_alert/secondPage.dart';
import 'package:scene_alert/localNotificationsHelper.dart';

// 7:44 

class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() => _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final notifications = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('blue_foreground.png');
    final settingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload));
    notifications.initialize(
      InitializationSettings(settingsAndroid,settingsIOS),
      onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(payload:payload)),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: <Widget>[
        title('Basics'),
        RaisedButton(
          child: Text('Show notification'),
          onPressed: () => showOngoingNotification(notifications,
            title: 'Title', body: 'Body'),
        )
      ],
    )
  );

  Widget title(String text) => Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    ),
  );
}