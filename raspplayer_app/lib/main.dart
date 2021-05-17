import 'package:flutter/material.dart';
import 'package:raspplayer_app/Screens/AboutScreen.dart';
import 'package:raspplayer_app/Screens/DeviceOptionsScreen.dart';
import 'package:raspplayer_app/Screens/HelpScreen.dart';
import 'package:raspplayer_app/Screens/LibaryScreen.dart';
import 'package:raspplayer_app/Screens/PlaylistsScreen.dart';
import 'package:raspplayer_app/Screens/MainScreen.dart';
import 'package:raspplayer_app/Screens/PlaylistScreen.dart';
import 'package:raspplayer_app/Screens/StatisticsScreen.dart';
import 'package:raspplayer_app/Screens/UserListScreen.dart';

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
        primaryColor: Color.fromRGBO(0, 1, 49, 1),
        accentColor: Colors.blue,
        sliderTheme: SliderThemeData(
          activeTrackColor: Color.fromRGBO(0, 1, 49, 1),
          thumbColor: Color.fromRGBO(0, 1, 49, 1)
        ),
        backgroundColor: Color.fromRGBO(218, 218, 218, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      routes: {
        'About': (context) => AboutScreen(),
        'Connect': (context) => ConnectScreen(),
        'DeviceOptions': (context) => DeviceOptionsScreen(),
        'Help': (context) => HelpScreen(),
        'Library': (context) => LibraryScreen(),
        'Playlists': (context) => PlaylistsScreen(),
        'Main': (context) => MainScreen(),
        'Statistics': (context) => StatisticsScreen(),
        'UserList': (context) => UserListScreen(),
        'Playlist': (context) => PlaylistScreen(),
      },
    );
  }
}


