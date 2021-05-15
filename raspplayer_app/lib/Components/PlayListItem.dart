import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayListItem extends StatelessWidget {
  final int id;
  final String playlistTitle;
  final String username;
  final int totalSongs;

  PlayListItem({this.id, this.playlistTitle = 'Playlist', this.username = 'User', this.totalSongs});

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
                        Navigator.pushNamed(context, 'Main');
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