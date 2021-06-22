import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'package:raspplayer_app/model/Playlist.dart';
import 'dart:convert';
import 'package:raspplayer_app/model/User.dart';
import 'package:raspplayer_app/model/Song.dart';


class RestService {
  final String hostname = "http://10.0.0.14:5000";
  void testFetch() async{
    http.get(Uri.parse(hostname), headers: {
      "Accept": "application/json"
    }).then((value) => stderr.writeln(value.body));
  }

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
      stderr.writeln(response.body);
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
    final response = await http.get(Uri.parse(hostname + '/songs'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    //stderr.writeln(response.body);
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
    final response = await http.get(Uri.parse(hostname+ '/Session/queue/return'), headers: {
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

  Future<List<User>> getUsers() async{
    List<User> result = [];
    final response = await http.get(Uri.parse(hostname + '/Session/Users/return'), headers: {
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

  Future<bool> playCurrentSong() async {
    final response = await http.get(Uri.parse(hostname + '/session/currentSong/play'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> pauseResumeCurrentSong() async {
    final response = await http.post(Uri.parse(hostname + '/session/currentSong/pause'), headers: {
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
    final response = await http.get(Uri.parse(hostname + '/session/currentSong/skip'), headers: {
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
    final response = await http.put(Uri.parse(hostname + '/Session/Mute/' + username), headers: {
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

  Future<Map> getStatistic() async{
    Map result;
    final response = await http.get(Uri.parse(hostname + '/statistics'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      stderr.writeln(result["bestDj"]);
      return result;
    }
    return null;
  }

  Future<bool> addSongToQueue(Song song) async{
    final response = await http.put(Uri.parse(hostname + '/session/queue/add/' + song.id.toString()), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<Song> uploadSong(File file) async {
    var request = http.MultipartRequest('POST',Uri.parse(hostname + '/Library/upload'))
      ..files.add(await http.MultipartFile.fromPath('file', file.path, filename: file.path.split("/").last, contentType: MediaType('audio', 'mpeg')));
    request.headers.addAll({
      'Accept': 'application/json',
      'token': UserData.token,
    });
    final response = await request.send();
    stderr.writeln(response);
    return null;
  }

  Future<int> setVolume(int volume) async {
    final response = await http.post(Uri.parse(hostname+'/Session/Volume/'+volume.toString()), headers:  {
      'Accept': 'application/json',
      'token': UserData.token
    });
    if (response.statusCode == 200) {
      stderr.writeln(jsonDecode(response.body)['volume']);
      return  int.parse(jsonDecode(response.body)['volume']);
    }
    return -1;
  }

  Future<String> setSessionPin(String sessionPin) async {
    stderr.writeln(sessionPin);
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
    },
    body: json.encode({
    'playlistName': playlistName,
    }));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['playlistID'] as int;
    }
    stderr.writeln(response.body);
    return -1;
  }

  Future<bool> playPlaylist(int playlistID) async {
    final response = await http.post(
        Uri.parse(hostname+ '/session/playlist/play'),
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: json.encode({
          'playlistID': playlistID,
        })
    );
    return response.statusCode == 200;
  }

}

