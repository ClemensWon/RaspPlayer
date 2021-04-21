
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {

  test() {

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 1, 49, 1),
              ),
              child: Text(
                'RaspPlayer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Device Options'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'DeviceOptions');
              },
            ),
            ListTile(
              leading: Icon(Icons.connected_tv),
              title: Text('Connecting Screen'),
              onTap: () {
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