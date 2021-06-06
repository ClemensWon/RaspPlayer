class Song {
  String songTitle;
  String album;
  String username;
  String artist;
  int id;

  Song({this.songTitle, this.album, this.username, this.artist, this.id});

  factory Song.fromJson(final json) {
    return Song(songTitle: json['name'] as String, album: json['album'] as String,username: json['addedBy'] as String, artist: json['artist'] as String, id: json['id'] as int);
  }
}