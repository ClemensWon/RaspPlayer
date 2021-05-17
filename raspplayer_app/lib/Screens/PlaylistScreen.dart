import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'dart:io';

class PlaylistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  final List<SongListItem> songList = [];
  List<SongListItem> displayList = [];

  @override
  void initState() {
    super.initState();
    RestService restService = RestService();
    restService.getSongs().then((songs) => {
      setState(() {
        songs.forEach((song) {
          songList.add(SongListItem.fromSong(key: Key(song.id.toString()), song: song, child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  displayList.removeWhere((element) {
                    stderr.writeln(element.key == Key(song.id.toString()));
                    return element.key == Key(song.id.toString());
                  });
                });
              },
              color: Color.fromRGBO(0, 1, 49, 1)
          ),));
        });
        displayList = songList;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: ReorderableListView(
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
          )),
      floatingActionButton: ElevatedButton(
        child: SizedBox(
            width: 50,
            child: Text(
              "Hide",
              textAlign: TextAlign.center,
            )),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
