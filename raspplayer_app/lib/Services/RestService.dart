import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'package:raspplayer_app/model/Playlist.dart';
import 'dart:convert';
import 'package:raspplayer_app/model/User.dart';
import 'package:raspplayer_app/model/Song.dart';


class RestService {
  final String hostname = "http://192.168.0.101:5000";

  //Test functionality
  void testFetch() async{
    http.get(Uri.parse(hostname), headers: {
      "Accept": "application/json"
    }).then((value) => stderr.writeln(value.body));
  }

  //Login

  Future<bool> login(String nickname, String sessionPin, String deviceID) async {
    final response = await http.post(Uri.parse(hostname + '/login'), headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
    },
    body: json.encode({
      'username': nickname,
      'sessionPin': sessionPin,
      'deviceId': deviceID
    }));
    if (response.statusCode == 200) {
      UserData.token = json.decode(response.body)['token'] as String;
      UserData.nickname = nickname;
      UserData.role = 'User';
      return true;
    }
    return false;
  }
 
  Future<bool> masterLogin(String nickname, String password, String deviceID) async {
    final response = await http.post(Uri.parse(hostname + "/login/master"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    },
    body: json.encode({
      'username': nickname,
      'password': password,
      'deviceId': deviceID
    }));
    if (response.statusCode == 200) {
      //stderr.writeln(response.body);
      Map jsonObject = json.decode(response.body);
      UserData.token = jsonObject['token'] as String;
      UserData.nickname = nickname;
      UserData.role = 'Owner';
      return true;
    }
    return false;
  }

  Future<List<Song>> getSongs() async{
    List<Song> result = [];
    final response = await http.get(Uri.parse(hostname + '/library/songs'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    stderr.writeln(response.body);
    if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((element) {
          result.add(Song.fromJson(element));
        });
       return result;
    }
    return null;
  }

  Future<List<Song>> getQueue() async {
    List<Song> result = [];
    final response = await http.get(Uri.parse(hostname+ '/session/queue'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    if (response.statusCode == 200) {
      stderr.writeln(jsonDecode(response.body));
      jsonDecode(response.body).forEach((element) {
        result.add(Song.fromJson(element));
      });
      return result;
    }
    return null;
  }

  Future<bool> deleteSongFromQueue(int songID) async {
    final response = await http.put(Uri.parse(hostname + '/session/queue/delete/' + songID.toString()), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<List<User>> getUsers() async{
    List<User> result = [];
    final response = await http.get(Uri.parse(hostname + '/session/users/return'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    stderr.writeln(jsonDecode(response.body));
    if (response.statusCode == 200) {
      int idCounter = 0;
      jsonDecode(response.body).forEach((element) {
        result.add(new User(id: idCounter.toString(),username: element['username'],role: "User",isMuted: false, isBanned: false));
      });
      return result;
    }
    return null;
  }

  Future<bool> playQueue() async {
    final response = await http.post(Uri.parse(hostname + '/session/queue/play'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> pauseResumeCurrentSong() async {
    final response = await http.put(Uri.parse(hostname + '/session/currentSong/pause'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> likeCurrentSong() async {
    final response = await http.put(Uri.parse(hostname + '/session/currentSong/like'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> skipCurrentSong() async {
    final response = await http.put(Uri.parse(hostname + '/session/currentSong/skip'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> replayCurrentSong() async {
    final response = await http.get(Uri.parse(hostname + '/session/currentSong/replay'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> muteUser(String username) async {
    final response = await http.put(Uri.parse(hostname + '/session/mute/' + username), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> banUser(String deviceId) async {
    final response = await http.put(Uri.parse(hostname + '/users/ban/' + deviceId), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> unbanUser(String deviceId) async {
    final response = await http.put(Uri.parse(hostname + '/users/unban/' + deviceId), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> muteAll() async {
    final response = await http.put(Uri.parse(hostname + '/users/muteAll'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> kickAll() async {
    final response = await http.put(Uri.parse(hostname + '/users/kickAll'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }



  Future<bool> addSongToQueue(List<int> songIDList) async{
    final response = await http.post(Uri.parse(hostname + '/session/queue/addSongs'), headers: {
      'Accept': 'application/json',
      "content-type" : "application/json",
      'token': UserData.token
    },
    body: json.encode({
      'songIDs': songIDList,
    }));
    return response.statusCode == 200;
  }

  Future<Song> uploadSong(File file) async {
    var request = http.MultipartRequest('POST',Uri.parse(hostname + '/library/upload'))
      ..files.add(await http.MultipartFile.fromPath('file', file.path, filename: file.path.split("/").last, contentType: MediaType('audio', 'mpeg')));
    request.headers.addAll({
      'Accept': 'application/json',
      'token': UserData.token,
      'deviceID': UserData.deviceID
    });
    final response = await request.send();
    //stderr.writeln("abc");
    return null;
  }

  //statistics

  Future<Map> getStatistic() async{
    Map result;
    final response = await http.get(Uri.parse(hostname + '/statistics'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      //err.writeln(result["bestDj"]);
      return result;
    }
    return null;
  }

  //settings

  Future<int> setVolume(int volume) async {
    final response = await http.put(Uri.parse(hostname+'/session/volume/'+volume.toString()), headers:  {
      'Accept': 'application/json',
      'token': UserData.token
    });
    if (response.statusCode == 200) {
      //stderr.writeln(jsonDecode(response.body)['volume']);
      return  int.parse(jsonDecode(response.body)['volume']);
    }
    return -1;
  }

  Future<String> setSessionPin(String sessionPin) async {
    //stderr.writeln(sessionPin);
    final response = await http.post(Uri.parse(hostname + "/settings/sessionPin"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
      'token': UserData.token
    },
        body: json.encode({
          'newPin': sessionPin,
        }));
    if (response.statusCode==200) {
      return jsonDecode(response.body)['sessionPin'] as String;
    }
    return "";
  }

  Future<List<Playlist>> getPlaylists() async {
    List<Playlist> result = [];
    final response = await http.get(Uri.parse(hostname + '/session/playlists'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    stderr.write(response.body);
    if (response.statusCode == 200) {
      jsonDecode(response.body).forEach((element) {
        result.add(Playlist.fromJson(element));
      });
      return result;
    }
    return [];
  }

  Future<int> createPlaylist(String playlistName) async {
    final response = await http.put(Uri.parse(hostname+ '/session/playlist/create'), headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      'token': UserData.token,
    },
    body: json.encode({
      'playlistName': playlistName,
      'deviceID': UserData.deviceID
    }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['playlistID'] as int;
    }
    //stderr.writeln(response.body);
    return -1;
  }

  Future<bool> addSongToPlaylist(List<int> songIds, int playlistID) async {
    final response = await http.put(
      Uri.parse(hostname+'/session/playlist/addSongs'),
      headers: {
        'token': UserData.token,
        "content-type" : "application/json",
        "accept" : "application/json",
      },
      body: json.encode({
        'songIDs': songIds,
        'playlistID': playlistID.toString()
      })
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteSongFromPlaylist(int songID, int playlistID) async {
    final response = await http.delete(Uri.parse(hostname + '/session/playlist/deleteSong'), headers: {
      'Accept': 'application/json',
      "content-type" : "application/json",
      'token': UserData.token
    },
    body: jsonEncode({
      'songID': songID,
      'playlistID': playlistID
    })
    );
    return response.statusCode == 200;
  }

  Future<bool> playPlaylist(int playlistID) async {
    final response = await http.post(
        Uri.parse(hostname+ '/session/playlist/play'),
        headers: {
          'token': UserData.token,
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: json.encode({
          'playlistID': playlistID,
        })
    );
    return response.statusCode == 200;
  }

  Future<List<Song>> getSongsFromPlaylist(int playlistID) async{
    List<Song> result = [];
    final response = await http.get(Uri.parse(hostname + '/session/playlist/songs/' + playlistID.toString()), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    if (response.statusCode == 200) {
      jsonDecode(response.body).forEach((element) {
        result.add(Song.fromJson(element));
      });
      return result;
    }
    return null;
  }

}

