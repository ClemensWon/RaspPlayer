import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/model/Playlist.dart';

class PlayListItem extends StatelessWidget {
  final int id;
  final String playlistTitle;
  final String username;
  final int totalSongs;

  PlayListItem({this.id, this.playlistTitle = 'Playlist', this.username = 'User', this.totalSongs});

  factory PlayListItem.fromPlaylist(Playlist playList) {
    return PlayListItem(id: playList.id, playlistTitle:  playList.playlistName, username: playList.username, totalSongs: playList.songCount);
  }

  @override
  Widget build(BuildContext context) {
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              ListTile(
                leading: Icon(Icons.album),
                title: Text(
                    id.toString() + '. ' + playlistTitle
                ),
                subtitle: Text(
                    'created by ' + username
                ),
                trailing: Text(
                    totalSongs.toString() + ' Songs'
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'Playlist');
                      },
                      child: Text('Show Songs'),
                  ),
                  TextButton(
                      onPressed: () {
                        RestService restService = new RestService();
                        restService.playPlaylist(id).then((success) {
                          if (success) {
                            Navigator.pushNamed(context, 'Main');
                          }
                        });

                      },
                      child: Text('Start'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}