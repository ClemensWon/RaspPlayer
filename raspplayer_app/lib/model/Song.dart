class Song {
  String songTitle;
  String album;
  String username;
  String artist;
  String genre;
  int duration;
  int id;
  int skips;
  int likes;

  Song({this.songTitle, this.album, this.username, this.artist, this.id, this.duration, this.genre, this.skips, this.likes});

  factory Song.fromJson(final json) {
    return Song(songTitle: json['songName'] as String,
        album: json['album'] as String,
        username: json['addedBy'] as String,
        artist: json['interpretName'] as String,
        id: json['songID'] as int,
        duration: json['duration'],
        genre: json['genre'],
        skips:  json['skips'],
        likes: json['likes']
    );
  }
}