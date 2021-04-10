
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';

class DeviceOptionsScreen extends StatefulWidget {
@override
State<StatefulWidget> createState() => DeviceOptionsScreenState();
}

class DeviceOptionsScreenState extends State<DeviceOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Options'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin:EdgeInsets.all(10),
        child: Text(
          'SettingsScreen',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}