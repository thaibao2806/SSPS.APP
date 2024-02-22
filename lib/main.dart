import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssps_app/pages/homePage.dart';
import 'package:ssps_app/pages/welcomPage.dart';
import 'package:ssps_app/service/shared_service.dart';

Widget _defaultHome = const WelcomePage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  bool _result  = await SharedService.isLoggedIn();
  if(_result) {
    print(_result);
    _defaultHome = HomePage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: _defaultHome,
    );
  }
}