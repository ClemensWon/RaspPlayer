import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:raspplayer_app/model/Song.dart';

class RestService {
  Future<http.Response> testFetch() {
    return http.get(Uri.parse("http://10.0.0.2:5000"), headers: {
      "Accept": "application/json"
    });
  }

  Future<List<Song>> getSongs() async{
    List<Song> result = [];
    final response = await http.get(Uri.parse('http://10.0.0.2:5000/songs'), headers: {
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((element) {
          result.add(Song.fromJson(element));
        });
       return result;
    }
  }
}