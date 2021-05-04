import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  final String username;
  final bool adminViw;
  final bool allowMute;

  const UserListItem({Key key, this.username, this.adminViw, this.allowMute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (adminViw) {
      return ListTile(
        title: Text(username),
        trailing: SizedBox.fromSize(
          size: Size(100,30),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: Icon(Icons.volume_off), onPressed: () {}),
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
              IconButton(icon: Icon(Icons.volume_off), onPressed: () {}),
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
