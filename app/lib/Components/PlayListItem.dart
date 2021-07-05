import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/model/Playlist.dart';

class PlayListItem extends StatelessWidget {
  //id of the playlist
  final int id;
  //title of the playlist
  final String playlistTitle;
  //username of the user who created the playlist
  final String username;
  //the count of songs in the playlist
  final int totalSongs;

  final onReturn;

  //constructor
  PlayListItem({this.id, this.playlistTitle = 'Playlist', this.username = 'User', this.totalSongs, this.onReturn});

  //creates PlayListItem out of playlist object
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
                        //switches to the playlist screen
                        RestService restService = new RestService();
                        restService.getSongsFromPlaylist(id).then((result) {
                          Navigator.pushNamed(context, 'Playlist', arguments: {'playlist': result, 'isQueue': false, 'playlistID': id}).then((value){
                            //calls refresh methods
                            onReturn();
                          });
                        });
                      },
                      child: Text('Show Songs'),
                  ),
                  TextButton(
                      onPressed: () {
                        //switches to the main screen and plays the playlist
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