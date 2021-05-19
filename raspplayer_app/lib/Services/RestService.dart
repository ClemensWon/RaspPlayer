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