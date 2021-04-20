
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
      floatingActionButton: Container(
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'About');
            },
          child: Icon(Icons.info_outline,size: 30,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(50),
        child: Center(
          child: Wrap(
            spacing: 0,
            runSpacing: 10,
            children: <Widget>[
              Text(
                'RaspPlayer',
                style: TextStyle(fontSize: 28),
                textAlign: TextAlign.center,

              ),
              Text(
                'Type in a Nickname and the password to connect with the RaspPlayer!',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Nickname',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your Nickname',
                ),
              ),
              Text(
                'Password',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter the password',
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 150.0,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Check Password and save nickname
                    Navigator.pushReplacementNamed(context, 'Main');
                  },
                  icon: Icon(Icons.connected_tv),
                  label: Text(
                    'Connect',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}