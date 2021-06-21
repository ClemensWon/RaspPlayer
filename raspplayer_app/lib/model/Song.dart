class Song {
  String songTitle;
  String album;
  String username;
  String artist;
  String genre;
  int duration;
  int id;
  int skips;

  Song({this.songTitle, this.album, this.username, this.artist, this.id, this.duration, this.genre, this.skips});

  factory Song.fromJson(final json) {
    return Song(songTitle: json['songName'] as String,
        album: json['album'] as String,
        username: json['deviceId'].toString() as String,
        artist: json['artist'] as String,
        id: json['songId'] as int,
        duration: json['duration'],
        genre: json['genre'],
        skips:  json['skips']
    );
  }
}