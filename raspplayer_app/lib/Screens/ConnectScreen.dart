
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/DeviceInfoService.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class ConnectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConnectScreenState();
}

class ConnectScreenState extends State<ConnectScreen> {

  TextEditingController _nickname = TextEditingController();
  TextEditingController _sessionPin = TextEditingController();
  TextEditingController _masterPassword = TextEditingController();
  String dropdownValue = 'User';

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (dropdownValue == 'User') Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Session Pin',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              if (dropdownValue == 'User') TextField(
                controller: _sessionPin,
                decoration: InputDecoration(
                  hintText: 'Enter the session pin',
                ),
              ),
              if (dropdownValue == 'Box Owner') Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              if (dropdownValue == 'Box Owner') TextField(
                controller: _masterPassword,
                decoration: InputDecoration(
                  hintText: 'Enter the password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  'Connect as',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Color.fromRGBO(0, 1, 49, 1),),
                  underline: Container(
                    height: 2,
                    color: Color.fromRGBO(0, 1, 49, 1),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['User', 'Box Owner'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
    DeviceInfoService deviceInfoService = new DeviceInfoService();
    deviceInfoService.getDeviceId().then((value) {
      print(value);
    });
    RestService restService = new RestService();
    if (dropdownValue == "User") {
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
    } else {
      restService.masterLogin(_nickname.text, _masterPassword.text).then((recievedToken) {
        if (recievedToken) {
          Navigator.pushReplacementNamed(context, 'Main');
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('password is wrong'),
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
}