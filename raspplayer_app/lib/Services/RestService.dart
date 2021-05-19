import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:raspplayer_app/Services/UserData.dart';
import 'dart:convert';

import 'package:raspplayer_app/model/Song.dart';

class RestService {
  void testFetch() async{
    http.get(Uri.parse("http://10.0.0.2:5000"), headers: {
      "Accept": "application/json"
    }).then((value) => stderr.writeln(value.body));
  }

  Future<bool> login(String nickname, String sessionPin) async {
    final response = await http.post(Uri.parse('http://10.0.0.2:5000/login'), headers: {
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
    final response = await http.post(Uri.parse("http://10.0.0.2:5000/login/master"), headers: {
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
    final response = await http.get(Uri.parse('http://10.0.0.2:5000/songs?token='+UserData.token), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      //stderr.writeln(jsonDecode(response.body)["songs"]);
        jsonDecode(response.body)["songs"].forEach((element) {
          result.add(Song.fromJson(element));
        });
       return result;
    }
  }
}