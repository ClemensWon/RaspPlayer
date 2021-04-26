import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Now'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin:EdgeInsets.all(10),
        child: Text(
          'Main Screen',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Text(
          "Show Playlist"
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'Playlist');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}