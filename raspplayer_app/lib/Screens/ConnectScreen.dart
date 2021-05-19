
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class ConnectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectScreenState();
}

class ConnectScreenState extends State<ConnectScreen> {

  TextEditingController _nickname = TextEditingController();
  TextEditingController _sessionPin = TextEditingController();
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
                controller: _nickname,
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
                controller: _sessionPin,
                decoration: InputDecoration(
                  hintText: 'Enter the password',
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 150.0,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: OnConnect,
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

  OnConnect() {
    stderr.writeln({
      'username': _nickname.text,
      'sessionPin': _sessionPin.text
    });
    RestService restService = new RestService();
    restService.login(_nickname.text, _sessionPin.text).then((recievedToken) {
      if (recievedToken) {
        Navigator.pushReplacementNamed(context, 'Main');
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('session pin is wrong'),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );

      }
    });
  }
}