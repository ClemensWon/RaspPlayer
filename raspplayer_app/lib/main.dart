import 'package:flutter/material.dart';
import 'package:raspplayer_app/Screens/MainScreen.dart';
import 'package:raspplayer_app/Screens/SettingsScreen.dart';

import './Screens/ConnectScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaspPlayer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      routes: {
        'SettingsScreen': (context) => SettingsScreen(),
      },
    );
  }
}


