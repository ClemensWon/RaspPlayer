import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  final List<SongListItem> songList = <SongListItem>[
    SongListItem(
      key: Key('0 song'),
      songTitle: '0 Song',
      artist: 'Mozart',
      username: 'Clemens',
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {},
        color: Color.fromRGBO(0, 1, 49, 1)
      ),
    ),
    SongListItem(
        key: Key('1 song'),
        songTitle: '1 Song',
        artist: 'Mozart',
      username: 'Clemens',
      child: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {},
          color: Color.fromRGBO(0, 1, 49, 1)
      ),
    ),
  ];

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
            children: songList,
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
