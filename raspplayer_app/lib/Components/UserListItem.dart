import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:raspplayer_app/model/User.dart';

class UserListItem extends StatefulWidget {
  String username;
  final bool adminView;
  final bool allowMute;
  bool isMuted;

  @override
  State<StatefulWidget> createState() => UserListItemState(username: this.username, adminView: this.adminView, allowMute: this.allowMute, isMuted: this.isMuted);

  UserListItem({Key key, this.username, this.adminView, this.allowMute, this.isMuted}) : super(key: key);
}

class UserListItemState extends State<UserListItem> {
  String username;
  final bool adminView;
  final bool allowMute;
  bool isMuted;
  RestService rs = new RestService();

  UserListItemState.fromUser(User user, this.adminView, this.allowMute, this.isMuted) {
    this.username = user.username;
  }

  UserListItemState({this.username, this.adminView, this.allowMute, this.isMuted});

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
              IconButton(icon: Icon((isMuted) ? Icons.volume_off : Icons.volume_up), onPressed: () {
                //if
                rs.muteUser(username).then((success) {
                  if(success) {
                    setState(() {
                      isMuted = true;
                    });
                  }
                });
              }),
              IconButton(icon: Icon(Icons.person_remove), onPressed: () {}),
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
              IconButton(icon: Icon((isMuted) ? Icons.volume_off : Icons.volume_up), onPressed: () {
                rs.muteUser(username).then((success) {
                  if(success) {
                    setState(() {
                      isMuted = true;
                    });
                  }
                });
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
