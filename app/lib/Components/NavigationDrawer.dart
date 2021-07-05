
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/UserData.dart';

class NavigationDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 250,
              child: DrawerHeader(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.blue[100]
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Image(
                      image: AssetImage('assets/img/logo_withText.png'),
                      width: 200,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ),
            //switches to the main screen
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Now Playing'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Main');
              },
            ),
            //switches to the library screen
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Library'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Library');
              },
            ),
            //switches to the playlist screen
            ListTile(
              leading: Icon(Icons.playlist_play),
              title: Text('Playlists'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Playlists');
              },
            ),
            //switches to the user list screen
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('User List'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'UserList');
              },
            ),
            //switches to the statistic screen
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Statistics');
              },
            ),
            //switches to the device option screen, only for box owner visible
            if (UserData.role == 'Owner')ListTile(
              leading: Icon(Icons.settings),
              title: Text('Device Options'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'DeviceOptions');
              },
            ),
            //deletes username, role and token then switches to the connect screen
            ListTile(
              leading: Icon(Icons.cancel_presentation),
              title: Text('Disconnect'),
              onTap: () {
                UserData.role = '';
                UserData.nickname = '';
                UserData.token = '';
                Navigator.pushReplacementNamed(context, 'Connect');
              },
            ),
            //switches to the help screen
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Help');
              },
            ),
          ],
        ),
    );
  }
}