import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/model/Playlist.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:raspplayer_app/model/Song.dart';

class PlayListItem extends StatelessWidget {
  final int id;
  final String playlistTitle;
  final String username;
  final int totalSongs;
  final onReturn;

  PlayListItem({this.id, this.playlistTitle = 'Playlist', this.username = 'User', this.totalSongs, this.onReturn});

  factory PlayListItem.fromPlaylist(Playlist playList, final onReturn) {
    return PlayListItem(id: playList.id, playlistTitle:  playList.playlistName, username: playList.username, totalSongs: playList.songCount, onReturn: onReturn,);
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
                        RestService restService = new RestService();
                        restService.getSongsFromPlaylist(id).then((result) {
                          Navigator.pushNamed(context, 'Playlist', arguments: {'playlist': result, 'isQueue': false, 'playlistID': id}).then((value){
                            onReturn();
                          });
                        });
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