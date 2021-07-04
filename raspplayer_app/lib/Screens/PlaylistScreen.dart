import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:raspplayer_app/model/Song.dart';
import 'dart:io';

import 'package:raspplayer_app/Services/RestService.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  List<SongListItem> songList = [];
  List<SongListItem> displayList = [];
  List<Song> sourceList = [];
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    if(isFirst) {
      sourceList = arguments['playlist'];
      isFirst = false;
    }
    displayList = [];
    songList = [];

    sourceList.forEach((song) {
      songList.add(SongListItem.fromSong(
        key: Key(song.id.toString()),
        song: song,
        child: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
                RestService restService = new RestService();
                if (arguments['isQueue']) {
                  /*restService.deleteSongFromQueue(song.id).then((result) {
                    setState(() {
                      if (result) {
                        sourceList.removeWhere((element) {
                          return element.id == song.id;
                        });
                        songList.removeWhere((element) {
                          return element.key == new Key(song.id.toString());
                        });
                        displayList = songList;

                      }
                    });

                  });*/
                } else {
                  restService.deleteSongFromPlaylist(song.id, arguments['playlistID']).then((result) {
                    setState(() {
                      if (result) {
                        sourceList.removeWhere((element) {
                          stderr.write("SourceList ");
                          stderr.writeln(element.id == song.id);
                          return element.id == song.id;
                        });
                        songList.removeWhere((element) {
                          stderr.write(element);
                          stderr.write(song.id.toString());
                          stderr.writeln(element.key == Key(song.id.toString()));
                          return element.key == Key(song.id.toString());
                        });
                        displayList = songList;
                        stderr.write(displayList);
                      }
                    });

                  });
                }

            },
            color: Color.fromRGBO(0, 1, 49, 1)),
      ));
    });
    displayList = songList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: ListView(
            /*
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final SongListItem item = songList.removeAt(oldIndex);
                songList.insert(newIndex, item);
              });
            },
            */
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
