import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/UserListItem.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/Services/UserData.dart';
import 'dart:io';

class UserListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserListScreenState();
}

class UserListScreenState extends State<UserListScreen> {
  final bool _adminView = UserData.role == "Owner";
  final bool _allowMute = true;
  List<UserListItem> userListItem = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

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
        child: RefreshIndicator(
          onRefresh: () async{
            loadUser();
          },
          child: ListView(
            children: userListItem,
          ),
        )
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
                RestService rs = new RestService();
                rs.muteAll().then((success) {
                  if(success) {
                    setState(() {
                      List<UserListItem> tmp = [];
                      userListItem.forEach((element) {
                        tmp.add(new UserListItem(username: element.username, adminView: element.adminView, allowMute: element.allowMute, isMuted: true, isBanned: element.isBanned,));
                      });
                      userListItem = tmp;
                    });
                  }
                });
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
                RestService rs = new RestService();
                rs.kickAll().then((success) {
                  if(success) {
                    stderr.writeln('test');
                    setState(() {
                      List<UserListItem> tmp = [];
                      userListItem.forEach((element) {
                        tmp.add(new UserListItem(username: element.username, adminView: element.adminView, allowMute: element.allowMute, isMuted: element.isMuted, isBanned: true));
                      });
                      userListItem = tmp;
                    });
                  }
                });
              },
            )
          ]
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void loadUser() {
    userListItem = [];
    RestService rs = new RestService();
    rs.getUsers().then((result) {
      int keyValue = 0;
      setState(() {
        result.forEach((element) {
          if(element.username == 'master') {
            userListItem = [...userListItem, new UserListItem(key: Key(keyValue.toString() + "userListItem"), username: element.username, adminView: false, allowMute: false, isMuted: element.isMuted, isBanned: element.isBanned)];
          }
          else {
            userListItem = [...userListItem, new UserListItem(key: Key(keyValue.toString() + "userListItem"), username: element.username, adminView: _adminView, allowMute: _allowMute, isMuted: element.isMuted, isBanned: element.isBanned,)];
          }
          keyValue++;
        });
      });
    });
  }
}
