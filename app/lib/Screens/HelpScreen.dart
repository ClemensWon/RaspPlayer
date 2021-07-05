
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
        title: Text('User Manuel'),
        ),
        drawer: NavigationDrawer(),
        body: Container(
          margin:EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                'Connect',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'The first thing a user has to do is connect the app to the rasplayer. This happens in the connect screen. The user has to input a nickname and the session pin to establish a connection. The nickname can be freely chosen and the sessionPin has to be provided by the owner.',
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child:
                Text(
                  'Songs',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 1, 49, 1),
                    fontSize: 28,
                  ),
                ),
              ),
              Text(
                'Search',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Go to the Library Screen and type in the name, interpret or album in the search field at the top. The matches should be displayed in the list below.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Add',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Select one or more songs with the checkbox in the library and click on the “add” button to add the selected songs to the current playlist.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Upload',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'To upload new songs to the song library you can click the “upload” button in the Library Screen. This will open the native file menu. Here you can choose an mp3 file for the upload.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Like',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'You can give songs a like by clicking the “thumbs up” button in the Main Screen. The likes are used for the statistics screen.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Skip',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'You can skip a song by clicking the “skip” icon in the main screen. The song will only be skipped if a certain percentage of users want to skip the song. This percentage can be configured by the session owner in the device setting screen.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Play again',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'The play again feature works similar to the skip function. You can request an enquor by tapping the play again button. If enough users request the repeat, the same song will be replayed.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Pause and Play',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'If you hit the pause button the current song gets paused and the button switches to the play icon. If the button is hit again the song starts playing and the button turns back into a pause icon.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Info',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'By pressing the info button you can view more information about a song. The following information is displayed: song title, interpret, album, user which added the song, the duration of the song, genres, the amount of likes a song received and the amount of skip votes the song received.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Show Queue',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Displays all the songs which are currently queued up in a new screen.',
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'Playlist',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'Show',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'To display all songs of a specific playlist, click the “show” button in the Playlist Screen.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Add',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'With the “add” button you can add the whole playlist to the current queue.',
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'User',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'Current User',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'All current users are displayed in the User List.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Mute',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'You can vote to mute a user by clicking the “mute” icon next to the user’s name in the User List. The effect only gets applied if a certain percentage of users hit the mute button.',
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'Statistic',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'The Statistic Screen shows different information about users and songs, for example “the most liked song”.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'This feature is currently not fully functional',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'Disconnect',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'After pressing the disconnect button in the navigation drawer, the user gets moved to the connect screen. Here he has to connect again to use the rest of the features',
                textAlign: TextAlign.justify,
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'Functions for the box Owner',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'Settings',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'Pin Code',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Here a box owner can change the session pin. The session pin is required for users to connect with the Raspplayer. The pin should only be shown to people which you want in your session.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Volume',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'With this slider it is possible to regulate the volume of the speakers.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Allow Upload',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Can be set if users should be able to upload new songs to the library.',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Text(
                'Limit Adding of Songs',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'If activated, a value can be set to limit the songs a user can add to the current playlist. ',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Text(
                'Skip Percentage',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'The Skip Percentage can be set by the Box Owner. A song will get skipped if more than the percentage of users vote for a skip.',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Text(
                'Allow Mute',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'This parameter decides if users are allowed to vote for the muting of other users.',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Text(
                'Mute Percentage',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'This slider is only shown if users are allowed to vote for the muting of other users. Here you can configure which percentage of users have to vote for the muting of other users.',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Text(
                'Mute Duration',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'The mute duration describes the time a user is muted after a mute vote was successful. The timespan is measured in minutes.',
                textAlign: TextAlign.justify,
              ),
              Text(
                  'This feature is currently not fully functional',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)
              ),
              Divider(
                thickness: 2,
                height: 50,
              ),
              Text(
                'User',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromRGBO(0, 1, 49, 1),
                  fontSize: 28,
                ),
              ),
              Text(
                'Mute',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'To mute a user you can click the “mute” icon next to the user’s name in the User List.',
                textAlign: TextAlign.justify,
              ),
              Text(
                'Ban',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'To ban a user from the RaspPlayer you can click the “remove person” button next to the “mute” button.',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
      )
   );
  }
  
}