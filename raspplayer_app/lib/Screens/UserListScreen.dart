import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/UserListItem.dart';
import 'package:raspplayer_app/Services/UserData.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  final bool _adminView = UserData.role == "Owner";
  final bool _allowMute = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            UserListItem(
              username: "Anna",
              allowMute: _allowMute,
              adminViw: _adminView,
            ),
            UserListItem(
              username: "Bob",
              allowMute: _allowMute,
              adminViw: _adminView,
            ),
            UserListItem(
              username: "Clemens",
              allowMute: _allowMute,
              adminViw: _adminView,
            )
          ],
        ),
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_adminView) ElevatedButton(
              child: SizedBox(
                  width: 70,
                  child:Text(
                    "Mute all",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
              ),
              onPressed: () {
                //...
              },

            ),
            if (_adminView) ElevatedButton(
              child: SizedBox(
                  width: 70,
                  child:Text(
                    "Kick all",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
              ),
              onPressed: () {

              },
            )
          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
