import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/PlayListItem.dart';

class PlaylistsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistsScreenState();
}

class PlaylistsScreenState extends State<PlaylistsScreen> {
  final List<PlayListItem> playlistList = <PlayListItem>[
    PlayListItem(
      id: 1,
      playlistTitle: 'Awesome Mix',
      username: 'Michi',
      totalSongs: 30,
    ),
    PlayListItem(
      id: 2,
      playlistTitle: 'Ur geile Oldies',
      username: 'Clemens',
      totalSongs: 69,
    ),
    PlayListItem(
      id: 3,
      playlistTitle: 'AustroPop, gemma!',
      username: 'Martin',
      totalSongs: 44,
    ),
  ];

  Widget playListItemTemplate(playlist) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: <Widget> [
          Text(
            playlist.playlistTitle,
          ),
          SizedBox(height: 6),
          Text(playlist.username),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlists'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: ListView(
            children: playlistList,
          ),
      )
    );
  }
}
