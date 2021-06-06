import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/Services/UserData.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  final bool admin = true;
  final String currentSong = 'current Song';
  RestService _restService = new RestService();
  bool _isLikedSong = false;
  bool _isSkipped = false;
  bool _isReplay = false;
  bool _isPlaying = true;
  final String songTitle = 'Song1';
  final String artist = 'Artist1';
  final String album = 'Album1';
  final String user = 'User1';

  displayErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('error with connection to the server'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Code to execute.
            },
          ),
        )
    );
  }

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
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(25, 50, 25, 25),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 1, 49, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    songTitle,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'from ' + artist,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    album,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/img/gif_MusicEffect.gif', width: 150),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child:
                    Text(
                      album,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/img/icon_Plus.png', color: Colors.black54),

                ),
                IconButton(
                  onPressed: () {
                    _restService.likeCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          _isLikedSong = true;
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_Like.png', color: (_isLikedSong)? Colors.blue : Colors.black54),
                ),
                IconButton(
                  onPressed: () {
                    _restService.replayCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          _isReplay = true;
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_Again.png', color: (_isReplay)? Colors.blue : Colors.black54),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            elevation: 16,
                            child: Container(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                                child: ListView(
                                  children: <Widget>[
                                    SizedBox(height:20),
                                    Center(
                                      child: Text("Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Songname" + ": " + currentSong),
                                          SizedBox(height: 30),
                                          Text("Interpret" + ": " + artist),
                                          SizedBox(height: 30),
                                          Text("Album" + ": " + album),
                                          SizedBox(height: 30),
                                          Text("Added by" + ": " + user),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                    );
                  },
                  icon: Image.asset('assets/img/icon_Info.png', color: Colors.black54),
                ),
                IconButton(
                  onPressed: () {
                    _restService.skipCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          _isSkipped = true;
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_PlayNext.png', color: (_isSkipped)? Colors.blue : Colors.black54),
                ),
                if (_isPlaying)IconButton(
                  onPressed: () {
                    setState(() {
                      _isPlaying = false;
                    });
                  },
                  icon: Image.asset('assets/img/icon_Pause.png', color: Colors.black54),
                ),
                if (!_isPlaying)IconButton(
                    icon: Image.asset('assets/img/icon_Play.png', color: Colors.black54),
                    onPressed: () {
                      setState(() {
                        _isPlaying = true;
                      });
                    }),
                if (UserData.role == 'Owner')IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/img/icon_Power.png', color: Colors.black54),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              indent: 30,
              endIndent: 30,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 15, 25, 15),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    ListTile(
                      title: Text(
                          'Song1 - Artist1'
                      ),
                      subtitle: Text(
                          'added by User1'
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Song2 - Artist2'
                      ),
                      subtitle: Text(
                          'added by User2'
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Song3 - Artist3'
                      ),
                      subtitle: Text(
                          'added by User3'
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Song4 - Artist4'
                      ),
                      subtitle: Text(
                          'added by User4'
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Song5 - Artist5'
                      ),
                      subtitle: Text(
                          'added by User5'
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Song6 - Artist6'
                      ),
                      subtitle: Text(
                          'added by User6'
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: ElevatedButton(
          child: Text(
            "Show Playlist"
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'Playlist');
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}