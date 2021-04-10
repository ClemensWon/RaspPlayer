
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Library'),
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('User List'),
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Statistics'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Device Options'),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
            ),
          ],
        ),
    );
  }
}