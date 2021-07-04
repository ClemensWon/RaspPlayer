import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:flutter/foundation.dart';
import 'package:raspplayer_app/Screens/MainScreen.dart';
import 'package:raspplayer_app/Services/FilePickerService.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'dart:io';

class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryScreenSate();
}

class LibraryScreenSate extends State<LibraryScreen> {
  final FilePickerService filePickerService = new FilePickerService();
  List<SongListItem> songList = [];
  List<StatelessWidget> addToList = [];
  List<SongListItem> displayList = [];
  final RestService restService = new RestService();
  bool showFab = true;
  Map checked = {};

  //load Songs() and loadBottomSheetOptions() gets called once for each state object
  @override
  void initState() {
    super.initState();
    loadSongs();
    loadBottomSheetOptions();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    RestService restService = new RestService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Library'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        margin: EdgeInsets.all(10),
          //on refresh, reload songs and bottomSheetOptions
        child: RefreshIndicator(
          onRefresh: () async {
            loadSongs();
            loadBottomSheetOptions();
          },
          child: ReorderableListView(
            //input field for search function
            header: TextFormField(
              //check if string matches song title, artist or username
              onChanged: (String searchText) {
                setState(() {
                  displayList = songList.where((element) {
                    return element.username
                        .toUpperCase()
                        .contains(searchText.toUpperCase()) ||
                        element.artist
                            .toUpperCase()
                            .contains(searchText.toUpperCase()) ||
                        element.songTitle
                            .toUpperCase()
                            .contains(searchText.toUpperCase());
                  }).toList();
                });
              },
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                focusColor: Color.fromRGBO(0, 1, 49, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            //makes it possible to reorder items in the list
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final SongListItem item = songList.removeAt(oldIndex);
                songList.insert(newIndex, item);
              });
            },
            children: displayList,
          ),
        )
      ),
      floatingActionButton: Builder(
        builder: (context) =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (showFab)
            ElevatedButton(
              child: SizedBox(
                  width: 50,
                  child: Text(
                    "Add",
                    textAlign: TextAlign.center,
                  )),
              onPressed: () {
                setState(() {
                  showFab = false;
                });
                bottomSheetMethod(context);
              },
            ),
          if (showFab)
            ElevatedButton(
              child: SizedBox(
                  width: 50,
                  child: Text(
                    "Upload",
                    textAlign: TextAlign.center,
                  )),
              onPressed: () {
                filePickerService.getFile().then((file) {
                  restService.uploadSong(file).then((value){
                    loadSongs();
                  });
                  stderr.writeln(file);
                });
                stderr.writeln();
              },
            ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //get all songs from Database and save them in displayList
  void loadSongs() {
    songList = [];
    restService.getSongs().then((songs) => {
      setState(() {
        songs.forEach((song) {
          checked[song] = false;
          songList.add(SongListItem.fromSong(
            key: Key(song.id.toString()),
            song: song,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Checkbox(
                      key: Key(song.id.toString() + "_checkbox"),
                      value: checked[song],
                      onChanged: (changeValue) {
                        setState(() {
                          checked[song] = changeValue;
                        });
                      });
                }),
          ));
          displayList = songList;
        });
      })
    });
  }

  //load queue and playlist as option for adding songs
  void loadBottomSheetOptions() {
    addToList = [];
    addToList.add(Card(
        child: ListTile(
          title: Text("Queue"),
          onTap: () {
            List<int> songIDList = [];
            checked.forEach((key, value) {
              if (value) {
                songIDList.add(key.id);
              }
            });
            restService.addSongToQueue(songIDList).then((value) {
              Navigator.pushReplacementNamed(context, 'Main');
            });
          },
        )
    ));
    //get playlists from database and add them to list
    restService.getPlaylists().then((playlists) {
      playlists.forEach((element) {
        addToList.add(Card(
          child: ListTile(
            title: Text(element.playlistName),
            onTap: () {
              List<int> songIDList = [];
              checked.forEach((key, value) {
                if (value) {
                  songIDList.add(key.id);
                }
              });
              restService.addSongToPlaylist(songIDList, element.id).then((value) {
                Navigator.pushReplacementNamed(context, 'Playlists');
              });
            },
          ),
        ));
      });
    });
  }

  //displays the lists
  void bottomSheetMethod(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200,
              color: Colors.blueAccent,
              child: Center(
                child:  ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                    children: addToList,
                )
              ),
            )
    ).closed.then((value) {
      setState(() {
        showFab = true;
      });
    });
  }
}
