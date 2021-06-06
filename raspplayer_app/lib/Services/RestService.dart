import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:raspplayer_app/Services/UserData.dart';
import 'dart:convert';
import 'package:raspplayer_app/model/User.dart';
import 'package:raspplayer_app/model/Song.dart';

class RestService {
  final String hostname = "http://10.0.0.15:5000";
  void testFetch() async{
    http.get(Uri.parse(hostname), headers: {
      "Accept": "application/json"
    }).then((value) => stderr.writeln(value.body));
  }

  Future<bool> login(String nickname, String sessionPin) async {
    final response = await http.post(Uri.parse(hostname + '/login'), headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
    },
    body: json.encode({
      'username': nickname,
      'sessionPin': sessionPin
    }));
    if (response.statusCode == 200) {
      stderr.writeln(response.body);
      UserData.token = json.decode(response.body)['token'] as String;
      UserData.nickname = nickname;
      UserData.role = 'User';
      return true;
    }
    return false;
  }

  Future<bool> masterLogin(String nickname, String password) async {
    final response = await http.post(Uri.parse(hostname + "/login/master"), headers: {
      "content-type": "application/json",
      "accept": "application/json",
    },
    body: json.encode({
      'username': nickname,
      'password': password
    }));
    stderr.writeln("abc");
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
    if (response.statusCode == 200) {
      //stderr.writeln(jsonDecode(response.body)["songs"]);
        jsonDecode(response.body)["songs"].forEach((element) {
          result.add(Song.fromJson(element));
        });
       return result;
    }
  }

  Future<List<User>> getUsers() async{
    List<User> result = [];
    final response = await http.get(Uri.parse(hostname + '/Session/Users/return'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    if (response.statusCode == 200) {
      stderr.writeln(response.body);
      int idCounter = 0;
      jsonDecode(response.body).forEach((element) {
        result.add(new User(id: idCounter.toString(),username: element,role: "User",isMuted: false));
      });
      return result;
    }
  }

  Future<bool> likeCurrentSong() async {
    final response = await http.put(Uri.parse(hostname + '/session/currentSong/like'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    stderr.writeln(response.statusCode== 200);
    return response.statusCode == 200;
  }

  Future<bool> skipCurrentSong() async {
    final response = await http.get(Uri.parse(hostname + '/session/currentSong/replay'), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }

  Future<bool> replayCurrentSong() async {
    final response = await http.get(Uri.parse(hostname + '/session/currentSong/skip'), headers: {
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
}

