import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class Notification {
  bool notification;

  Notification() {
    notification = true;
  }

  bool getNotification() => notification;

  void setNotification(bool val) => notification = val;

  void notifier() {
    if (notification) {
      ///TODO Implémenter les notifications si quelqu'un est motivé

    }
  }
}

class NotificationRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationRowState();
}

class _NotificationRowState extends State<NotificationRow> {
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
          child: Text('Notification : ',
              style: TextStyle(
                color: ThemeProvider.themeOf(context)
                    .data
                    .textTheme
                    .headline1
                    .color,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 25, 35, 35),
          child: Switch(
            value: notification,
            onChanged: (value) {
              setState(() {
                Notification().notification = value;  //Update dans la case notification
                notification = value; //Update de l'affichage
              });
            },
          ),
        )
      ],
    );
  }
}








/*

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
 */