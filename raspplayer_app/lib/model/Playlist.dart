class Playlist {
  String playlistName;
  String username;
  int id;
  int songCount;

  Playlist({this.playlistName, this.username, this.id, this.songCount});

  factory Playlist.fromJson(final json) {
    return Playlist(playlistName: json['playlistName'] as String,
        username: json['creator'] as String,
        //username: "Alex",
        id: json['playlistID'] as int,
        //songCount: json['songCount'] as int,
        songCount: json['numberOfSongs'] as int,
    );
  }
}