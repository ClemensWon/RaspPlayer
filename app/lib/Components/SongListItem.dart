import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/model/Song.dart';

class SongListItem extends StatelessWidget {
  //song title
  final String songTitle;
  //name of the artist
  final String artist;
  //name of the user who uploaded the song
  final String username;
  //custom widget trailing
  final Widget child;

  SongListItem({Key key, this.songTitle, this.artist, this.username, this.child = null}) : super(key: key);

  //factory for creating SongListItem
  SongListItem.fromSong({Key key, Song song, Widget child = null}) :
    this.songTitle = song.songTitle,
    this.artist = song.artist,
    this.username = song.username,
    this.child = child,
    super(key: key);


  @override
  Widget build(BuildContext context) {
    //display if there is no trailing child widget
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
      //display if there is a trailing child display
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