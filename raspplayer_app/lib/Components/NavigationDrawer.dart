
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/UserData.dart';

class NavigationDrawer extends StatelessWidget {

  test() {

  }

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
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Now Playing'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Main');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Library'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Library');
              },
            ),
            ListTile(
              leading: Icon(Icons.playlist_play),
              title: Text('Playlists'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Playlists');
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('User List'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'UserList');
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'Statistics');
              },
            ),
            if (UserData.role == 'Owner')ListTile(
              leading: Icon(Icons.settings),
              title: Text('Device Options'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'DeviceOptions');
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel_presentation),
              title: Text('Disconnect'),
              onTap: () {
                UserData.role = '';
                UserData.nickname = '';
                Navigator.pushReplacementNamed(context, 'Connect');
              },
            ),
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