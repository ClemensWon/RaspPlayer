import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/model/Song.dart';

class SongListItem extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String username;
  final Widget child;

  SongListItem({Key key, this.songTitle, this.artist, this.username, this.child = null}) : super(key: key);

  SongListItem.fromSong({Key key, Song song, Widget child = null}) :
    this.songTitle = song.songTitle,
    this.artist = song.artist,
    this.username = song.username,
    this.child = child,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return ListTile(
        title: Text(
            songTitle + ' - ' + artist
        ),
        subtitle: Text(
            'added by ' + username
        ),
        trailing: child,
      );
    } else {
      return ListTile(
        title: Text(
            songTitle + ' - ' + artist
        ),
        subtitle: Text(
            'added by ' + username
        ),
      );
    }
  }
  
}