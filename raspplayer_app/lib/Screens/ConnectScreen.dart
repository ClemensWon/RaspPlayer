
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectScreenState();

}

class ConnectScreenState extends State<ConnectScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin:EdgeInsets.all(10),
        child: Text(
          'Connect Screen',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}