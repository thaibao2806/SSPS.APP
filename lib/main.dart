import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssps_app/components/notification/local_notification.dart';
import 'package:ssps_app/firebase_options.dart';
import 'package:ssps_app/pages/homePage.dart';
import 'package:ssps_app/pages/reportPage.dart';
import 'package:ssps_app/pages/todolistPage.dart';
import 'package:ssps_app/pages/welcomPage.dart';
import 'package:ssps_app/push_notification.dart';
import 'package:ssps_app/service/shared_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ssps_app/pages/pomodoroPage.dart';

Widget _defaultHome = const WelcomePage();

final naviatorKey = GlobalKey<NavigatorState>();

Future _firebaseBackgroundMessage(RemoteMessage message) async {
  print(message);
  if (message.notification != null) {
    print("Some notification  received");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotifications.init();

  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      naviatorKey.currentState
            ?.push(MaterialPageRoute(builder: (context) => PomodoroPage()));
    });
  }
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['page'] != null) {
      String page = message.data['page'];
      print("background notification tapped, page: $page");

      if (page == 'home') {
        naviatorKey.currentState
            ?.push(MaterialPageRoute(builder: (context) => HomePage()));
      } else if (page == 'todo') {
        naviatorKey.currentState
            ?.push(MaterialPageRoute(builder: (context) => TodolistPage()));
      }
    }
  });

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  PushNotifications.init();
  PushNotifications.localNotiInit();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });


  bool _result = await SharedService.isLoggedIn();
  if (_result) {
    print(_result);
    _defaultHome = ReportPage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: naviatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: _defaultHome,
      routes: {
        // '/': (context) => HomePage(),
      },
    );
  }
}
