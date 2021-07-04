import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'package:raspplayer_app/model/Playlist.dart';
import 'dart:convert';
import 'package:raspplayer_app/model/User.dart';
import 'package:raspplayer_app/model/Song.dart';


class RestService {
  final String hostname = "http://10.0.0.21:5000";

  //Test functionality
  void testFetch() async{
    http.get(Uri.parse(hostname), headers: {
      "Accept": "application/json"
    }).then((value) => stderr.writeln(value.body));
  }

  //Login as a normal user
  Future<bool> login(String nickname, String sessionPin, String deviceID) async {
    final response = await http.post(
        Uri.parse(hostname + '/login'),
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        },
        body: json.encode({
          'username': nickname,
          'sessionPin': sessionPin,
          'deviceId': deviceID
        })
    );
    //checks if the response was successful
    if (response.statusCode == 200) {
      //saves the token, nickname and role into the userdata service
      UserData.token = json.decode(response.body)['token'] as String;
      UserData.nickname = nickname;
      UserData.role = 'User';
      return true;
    }
    return false;
  }

  //login for the box owner
  Future<bool> masterLogin(String nickname, String password, String deviceID) async {
    final response = await http.post(
        Uri.parse(hostname + "/login/master"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
        },
        body: json.encode({
          'username': nickname,
          'password': password,
          'deviceId': deviceID
        })
    );
    //checks if the response was successful
    if (response.statusCode == 200) {
      //saves the token, nickname and role into the userdata service
      Map jsonObject = json.decode(response.body);
      UserData.token = jsonObject['token'] as String;
      UserData.nickname = nickname;
      UserData.role = 'Owner';
      return true;
    }
    return false;
  }

  //gets all song saved on the back end
  Future<List<Song>> getSongs() async{
    List<Song> result = [];
    final response = await http.get(
        Uri.parse(hostname + '/library/songs'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    if (response.statusCode == 200) {
      //parses the json elements from the response array into Song class objects
        jsonDecode(response.body).forEach((element) {
          result.add(Song.fromJson(element));
        });
       return result;
    }
    //returns null on error
    return null;
  }

  //gets all song currently waiting in the backend queue
  Future<List<Song>> getQueue() async {
    List<Song> result = [];
    final response = await http.get(
        Uri.parse(hostname+ '/session/queue'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    if (response.statusCode == 200) {
      //parses the json elements from the response array into Song class objects
      jsonDecode(response.body).forEach((element) {
        result.add(Song.fromJson(element));
      });
      return result;
    }
    //returns null on error
    return null;
  }

  //this function is currently not implemented in the backend
  /*
  Future<bool> deleteSongFromQueue(int songID) async {
    final response = await http.put(Uri.parse(hostname + '/session/queue/delete/' + songID.toString()), headers: {
      'Accept': 'application/json',
      'token': UserData.token
    });
    return response.statusCode == 200;
  }
*/

  //gets all user currently in the session
  Future<List<User>> getUsers() async{
    List<User> result = [];
    final response = await http.get(
        Uri.parse(hostname + '/session/users/return'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token,
        });
    if (response.statusCode == 200) {
      int idCounter = 0;
      //parses the json elements from the response array into User class objects
      jsonDecode(response.body).forEach((element) {
        result.add(new User(id: idCounter.toString(),username: element['username'],role: "User",isMuted: false, isBanned: element['banned'] == 1 ? true : false));
      });
      return result;
    }
    //returns null on error
    return null;
  }

  //starts playing the queue
  Future<bool> playQueue() async {
    final response = await http.post(
        Uri.parse(hostname + '/session/queue/play'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

//pauses or resumes the current song
  Future<bool> pauseResumeCurrentSong() async {
    final response = await http.put(
        Uri.parse(hostname + '/session/currentSong/pause'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //likes the current song
  Future<bool> likeCurrentSong() async {
    final response = await http.put(
        Uri.parse(hostname + '/session/currentSong/like'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //votes to skip the current song
  Future<bool> skipCurrentSong() async {
    final response = await http.put(
        Uri.parse(hostname + '/session/currentSong/skip'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //otes for a replay of the current song
  Future<bool> replayCurrentSong() async {
    final response = await http.get(
        Uri.parse(hostname + '/session/currentSong/replay'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //votes for the muting of a user
  Future<bool> muteUser(String username) async {
    final response = await http.put(
        Uri.parse(hostname + '/session/mute/' + username),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //lets a box owner ban a user
  Future<bool> banUser(String deviceId) async {
    final response = await http.put(
        Uri.parse(hostname + '/users/ban/' + deviceId),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //lets a box owner unban a user
  Future<bool> unbanUser(String deviceId) async {
    final response = await http.put(
        Uri.parse(hostname + '/users/unban/' + deviceId),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //lets a box owner mute all user
  Future<bool> muteAll() async {
    final response = await http.put(
        Uri.parse(hostname + '/users/muteAll'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //lets a box owner kick out all user out of the session
  Future<bool> kickAll() async {
    final response = await http.put(
        Uri.parse(hostname + '/users/kickAll'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    //returns true if the request was successful
    return response.statusCode == 200;
  }


  //adds a song to the queue
  Future<bool> addSongToQueue(List<int> songIDList) async{
    final response = await http.post(
        Uri.parse(hostname + '/session/queue/addSongs'),
        headers: {
          'Accept': 'application/json',
          "content-type" : "application/json",
          'token': UserData.token
        },
        body: json.encode({
          'songIDs': songIDList,
        }));
    //returns true if the response is true
    return response.statusCode == 200;
  }

  //uploads a song via a multi part request
  Future<Song> uploadSong(File file) async {
    var request = http.MultipartRequest('POST',Uri.parse(hostname + '/library/upload'))
      ..files.add(await http.MultipartFile.fromPath('file', file.path, filename: file.path.split("/").last, contentType: MediaType('audio', 'mpeg')));
    request.headers.addAll({
      'Accept': 'application/json',
      'token': UserData.token,
      'deviceID': UserData.deviceID
    });
    return null;
  }

  //gets statistic information is only implemented with mock data in the back end
  Future<Map> getStatistic() async{
    Map result;
    final response = await http.get(
        Uri.parse(hostname + '/statistics'),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token,
        });
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
      //returns a map object
      return result;
    }
    return null;
  }

  //changes the volume of the speaker
  Future<int> setVolume(int volume) async {
    final response = await http.put(
        Uri.parse(hostname+'/session/volume/'+volume.toString()),
        headers:  {
          'Accept': 'application/json',
          'token': UserData.token
        });
    if (response.statusCode == 200) {
      //returns the new volume
      return  int.parse(jsonDecode(response.body)['volume']);
    }
    //returns -1 if the request has an error
    return -1;
  }

  //changes the sessionPin
  Future<String> setSessionPin(String sessionPin) async {
    final response = await http.post(
        Uri.parse(hostname + "/settings/sessionPin"),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          'token': UserData.token
        },
        body: json.encode({
          'newPin': sessionPin,
        }));
    if (response.statusCode==200) {
      //returns the new sessionPin
      return jsonDecode(response.body)['sessionPin'] as String;
    }
    //returns null on error
    return null;
  }

  //gets all the playlists
  Future<List<Playlist>> getPlaylists() async {
    List<Playlist> result = [];
    final response = await http.get(Uri.parse(hostname + '/session/playlists'), headers: {
      'Accept': 'application/json',
      'token': UserData.token,
    });
    if (response.statusCode == 200) {
      //parses the json elements from the response array into Playlist class objects
      jsonDecode(response.body).forEach((element) {
        result.add(Playlist.fromJson(element));
      });
      //returns playlists array
      return result;
    }
    return [];
  }

  //creates a new playlist
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
      //returns the id of the newly created playlist
      return jsonDecode(response.body)['playlistID'] as int;
    }
    return -1;
  }

  //adds a song to a playlist
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
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //deletes a song from the playlist
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
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //starts playing a new playlist
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
    //returns true if the request was successful
    return response.statusCode == 200;
  }

  //gets all song from a playlist
  Future<List<Song>> getSongsFromPlaylist(int playlistID) async{
    List<Song> result = [];
    final response = await http.get(
        Uri.parse(hostname + '/session/playlist/songs/' + playlistID.toString()),
        headers: {
          'Accept': 'application/json',
          'token': UserData.token
        });
    if (response.statusCode == 200) {
      //parses the response array into Song objects
      jsonDecode(response.body).forEach((element) {
        result.add(Song.fromJson(element));
      });
      //returns Song array
      return result;
    }
    //returns null if the response has an error
    return null;
  }

}

