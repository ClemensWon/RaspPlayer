import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/DeviceInfoService.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/model/User.dart';

class UserListItem extends StatefulWidget {
  String username;
  final bool adminView;
  final bool allowMute;
  bool isMuted;
  bool isBanned;

  @override
  State<StatefulWidget> createState() => UserListItemState(username: this.username, adminView: this.adminView, allowMute: this.allowMute, isMuted: this.isMuted, isBanned: this.isBanned);

  UserListItem({Key key, this.username, this.adminView, this.allowMute, this.isMuted, this.isBanned}) : super(key: key);
}

class UserListItemState extends State<UserListItem> {
  //name of a user
  String username;
  //if true shows the buttons available to the admin
  final bool adminView;
  //shows if muting is allowed
  final bool allowMute;
  //shows if a user is muted
  bool isMuted;
  //shows if a user is banned
  bool isBanned = false;
  RestService rs = new RestService();
  DeviceInfoService dis = new DeviceInfoService();

  UserListItemState.fromUser(User user, this.adminView, this.allowMute, this.isMuted, this.isBanned) {
    this.username = user.username;
  }

  UserListItemState({this.username, this.adminView, this.allowMute, this.isMuted, this.isBanned});

  @override
  Widget build(BuildContext context) {
    if (adminView) {
      return ListTile(
        title: Text(username),
        trailing: SizedBox.fromSize(
          size: Size(100,30),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //mutes a user
              IconButton(icon: Icon((isMuted) ? Icons.volume_off : Icons.volume_up), onPressed: () {
                if(!isMuted) {
                  rs.muteUser(username).then((success) {
                    if(success) {
                      setState(() {
                        isMuted = true;
                      });
                    }
                  });
                }
                else {
                  //unmuteUser()
                }

              }),
              //bans a user
              IconButton(icon: Icon((isBanned) ? Icons.person_add : Icons.person_remove), onPressed: () {
                if(!isBanned) {
                  rs.banUser(dis.getDeviceId().toString()).then((success) {
                    if(success) {
                      setState(() {
                        isBanned = true;
                      });
                    }
                  });
                }
                else {
                  rs.unbanUser(dis.getDeviceId().toString()).then((success) {
                    if(success) {
                      setState(() {
                        isBanned = false;
                      });
                    }
                  });
                }
              }),
            ],
          ),
        ),
      );
    }
    if (allowMute) {
      return ListTile(
        title: Text(username),
        trailing: SizedBox.fromSize(
          size: Size(100,30),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //mutes a user
              IconButton(icon: Icon((isMuted) ? Icons.volume_off : Icons.volume_up), onPressed: () {
                if(!isMuted) {
                  rs.muteUser(username).then((success) {
                    if(success) {
                      setState(() {
                        isMuted = true;
                      });
                    }
                  });
                }
                else {
                  //unmuteUser()
                }
              }),
            ],
          ),
        ),
      );
    }
    return ListTile(
      title: Text(username),
    );
  }
}
