
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'package:raspplayer_app/model/Song.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  final bool admin = true;
  final String currentSong = 'current Song';

  RestService _restService = new RestService();

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
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'Library');
                  },
                  icon: Image.asset('assets/img/icon_Plus.png', color: Colors.black54),

                ),
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
                                          Text("Interpret" + ": " + artist),
                                          SizedBox(height: 10),
                                          Text("Album" + ": " + album),
                                          SizedBox(height: 10),
                                          Text("Added by" + ": " + user),
                                          SizedBox(height: 10),
                                          Text("Duration" + ": " + user),
                                          SizedBox(height: 10),
                                          Text("Genre" + ": " + user),
                                          SizedBox(height: 10),
                                          Text("Likes" + ": " + user),
                                          SizedBox(height: 10),
                                          Text("Skips" + ": " + user),
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
                          mainScreenProvider.setIsSkipped(true);
                        } else {
                          displayErrorMessage();
                        }
                      });
                    });
                  },
                  icon: Image.asset('assets/img/icon_PlayNext.png', color: (mainScreenProvider.getIsSkipped())? Colors.blue : Colors.black54),
                ),
                if (mainScreenProvider.getIsPlaying())IconButton(
                  onPressed: () {
                    setState(() {
                      mainScreenProvider.setIsPlaying(false);
                    });
                  },
                  icon: Image.asset('assets/img/icon_Pause.png', color: Colors.black54),
                ),
                if (!mainScreenProvider.getIsPlaying())IconButton(
                    icon: Image.asset('assets/img/icon_Play.png', color: Colors.black54),
                    onPressed: () {
                      _restService.playCurrentSong().then((success) {
                        if (success) {
                          setState(() {
                            mainScreenProvider.setIsPlaying(true);
                          });
                        } else {
                          displayErrorMessage();
                        }
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
                  children: mainScreenProvider.getQueue()
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