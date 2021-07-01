import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/CreatePlaylistDialog.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/PlayListItem.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class PlaylistsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlaylistsScreenState();
}

class PlaylistsScreenState extends State<PlaylistsScreen> {
  List<PlayListItem> playlistList = <PlayListItem>[];

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
  void initState() {
    super.initState();
    loadPlaylists();
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
          child: RefreshIndicator(
            onRefresh: () async{
              loadPlaylists();
            },
            child: ListView(
              children: playlistList,
            ),
          )
      ),
      floatingActionButton: IconButton(icon: Icon(Icons.add_circle),
        onPressed: () {
          showDialog(context: context, builder: (build) {
            return CreatePlayListDialog();
          }).then((value) {
            loadPlaylists();
          });
        },
        iconSize: 48,
        color: Colors.blue,
      ),
    );
  }

  void loadPlaylists() {
    RestService restService = new RestService();
    final List<PlayListItem> tmp = <PlayListItem>[];
    restService.getPlaylists().then((result) {
      setState((){
        result.forEach((element) {
          tmp.add(new PlayListItem.fromPlaylist(element, loadPlaylists));
        });
        playlistList = tmp;
      });

    });
  }
}
