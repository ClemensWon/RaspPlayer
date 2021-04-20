
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryScreenSate();
}

class LibraryScreenSate extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Library'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin:EdgeInsets.all(10),
        child: Text(
          'Library Screen',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}