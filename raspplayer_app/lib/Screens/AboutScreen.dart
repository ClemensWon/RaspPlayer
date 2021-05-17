
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButton: Container(
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'Connect');
          },
          child: Icon(Icons.arrow_back,size: 30,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(50,0,50,0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 0,
              runSpacing: 10,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,30,0,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/img/logo_placeholder.png'),
                        width: 120,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Alpha Version 1.0',
                        style: TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RaspPlayer',
                        style: TextStyle(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Text(
                  'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan> [
                        TextSpan(
                          text: 'Terms of Use\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music.\n\n',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                                'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. \n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextSpan(
                          text: 'General Use and Data Privacy\n\n',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: 'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music.\n\n',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. '
                              'RaspPlayer is a special Application which can build up a connection to a RaspBox to play music. \n\n\n',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}