
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'package:raspplayer_app/model/Song.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  final bool admin = true;
  final bool emptyQueue = true;
  final String currentSong = 'current Song';

  RestService _restService = new RestService();

  String _songTitle = '';
  String _artist = '';
  String _album = '';
  String _user = '';
  String _duration = '';
  String _genre = '';
  String _skips = '';
  String _likes = '';
  List<SongListItem> queue = [];
  List<Song> songs = [];

  displayErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('error with connection to the server'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
            },
          ),
        )
    );
  }

  @override
  void initState(){
    super.initState();
    loadQueue();
    //continuously makes requests to the backend for UI update
    Timer.periodic(new Duration(seconds: 1), (timer) {
      var route = ModalRoute.of(context);
      if (true || route.settings.name == "Main") {
        loadQueue();
      } else {
        timer.cancel();
      }
    });

    //MainScreenProvider mainScreenProvider = Provider.of<MainScreenProvider>(context);

  }

  @override
  Widget build(BuildContext context) {
    //responsible for state management
    MainScreenProvider mainScreenProvider = Provider.of<MainScreenProvider>(context);
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
                    _songTitle,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'from ' + _artist,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    _album,
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
                      _user,
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
                //for adding a song, switch to the LibraryScreen
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'Library');
                  },
                  icon: Image.asset('assets/img/icon_Plus.png', color: Colors.black54),
                ),
                //increase the likes of the song
                IconButton(
                  onPressed: () {
                    _restService.likeCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          mainScreenProvider.setIsLikedSong(true);
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_Like.png', color: (mainScreenProvider.getIsLikedSong())? Colors.blue : Colors.black54),
                ),
                //replays the current song
                IconButton(
                  onPressed: () {
                    _restService.replayCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          mainScreenProvider.setIsReplay(true);
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_Again.png', color: (mainScreenProvider.getIsReplay())? Colors.blue : Colors.black54),
                ),
                //displays information about the current song in a popup
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
                                          SizedBox(height: 10),
                                          Text("Interpret" + ": " + _artist),
                                          SizedBox(height: 10),
                                          Text("Album" + ": " + _album),
                                          SizedBox(height: 10),
                                          Text("Added by" + ": " + _user),
                                          SizedBox(height: 10),
                                          Text("Duration" + ": " + _duration),
                                          SizedBox(height: 10),
                                          Text("Genre" + ": " + _genre),
                                          SizedBox(height: 10),
                                          Text("Likes" + ": " + _likes),
                                          SizedBox(height: 10),
                                          Text("Skips" + ": " + _skips),
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
                //skip to the next song in the queue
                IconButton(
                  onPressed: () {
                    _restService.skipCurrentSong().then((success) {
                      setState(() {
                        if (success) {
                          mainScreenProvider.setIsSkipped(true);
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_PlayNext.png', color: (mainScreenProvider.getIsSkipped())? Colors.blue : Colors.black54),
                ),
                //pause the current playlist
                IconButton(
                  onPressed: () {
                    _restService.pauseResumeCurrentSong().then((success) {
                      if (success) {
                        setState(() {
                          mainScreenProvider.setIsPlaying(!mainScreenProvider.getIsPlaying());
                        });
                      } else {
                        displayErrorMessage();
                      }
                    });
                  },
                  icon: (mainScreenProvider.getIsPlaying()) ?  Image.asset('assets/img/icon_Pause.png', color: Colors.black54) : Image.asset('assets/img/icon_Play.png', color: Colors.black54),
                ),
                if (UserData.role == 'Owner')IconButton(
                  onPressed: () {
                    _restService.playQueue().then((success) {
                      if (!success) {
                        displayErrorMessage();
                      }
                    });
                  },
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
                  children:queue
                ),
              ),
            ),
          ],
        ),
      ),
      //button which opens the current playlist
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: ElevatedButton(
          child: Text(
            "Show Playlist"
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'Playlist', arguments: {'playlist': songs, 'isQueue': true});
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //get the song queue from database
  void loadQueue() {
    _restService.getQueue().then((response) {
      if (response != []) {
        List<SongListItem> tmp = [];
        songs = response;
        setState(() {
          if (response.first.songTitle != null) {
            _songTitle = response.first.songTitle;
            _artist = response.first.artist;
            _album = response.first.album;
            _user = response.first.username;
            _duration = response.first.duration.toString();
            _genre = response.first.genre;
            _skips = response.first.skips.toString();
            _likes = response.first.likes.toString();
            response.forEach((element) {
              tmp.add(SongListItem.fromSong(song: element));
            });
            queue = tmp;
          }
          else {
            setState(() {
              _songTitle = "no song playing";
              _artist = '';
              _album = '';
              _user = '';
              _duration = '';
              _genre = '';
              _skips = '';
              _likes = '';
            });
          }
        });
      } else {
        setState(() {
          _songTitle = "no song playing";
          _artist = '';
          _album = '';
          _user = '';
          _duration = '';
          _genre = '';
          _skips = '';
          _likes = '';
        });
      }

    });
  }
}

class MainScreenProvider with ChangeNotifier {
  List<SongListItem> _queue = [];
  bool _isLikedSong = false;
  bool _isSkipped = false;
  bool _isReplay = false;
  bool _isPlaying = true;
  int keyCounter = 0;

  bool getIsLikedSong() {
    return this._isLikedSong;
  }

  void setIsLikedSong(isLikedSong) {
    this._isLikedSong = isLikedSong;
    notifyListeners();
  }

  bool getIsSkipped() {
    return this._isSkipped;
  }

  void setIsSkipped(isSkipped) {
    this._isSkipped = _isSkipped;
    notifyListeners();
  }

  bool getIsReplay() {
    return this._isReplay;
  }

  void setIsReplay(bool isReplay) {
    this._isReplay = isReplay;
    notifyListeners();
  }

  bool getIsPlaying() {
    return this._isPlaying;
  }

  void setIsPlaying(bool isPlaying) {
    this._isPlaying = isPlaying;
    notifyListeners();
  }

  void addToQueue(Song newSong) {
    this._queue.add(SongListItem.fromSong(song: newSong));
    List<SongListItem> tmp = _queue;
    this._queue = tmp;
    notifyListeners();
  }

  List<SongListItem> getQueue() {
    return this._queue;
  }
}