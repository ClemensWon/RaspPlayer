import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin:EdgeInsets.all(10),
        child: Text(
          'Playlist Screen',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}