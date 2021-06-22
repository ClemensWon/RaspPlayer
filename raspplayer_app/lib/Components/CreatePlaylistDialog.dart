
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class CreatePlayListDialog extends StatelessWidget{

  String _playlistName = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 16,
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Column(
            children: <Widget>[
              SizedBox(height:20),
              Center(
                child: Text("Create Playlist", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Playlist Name:"),
                    TextField(
                      onChanged: (String text) {
                        _playlistName = text;
                      },
                    ),
                    SizedBox.fromSize(size: Size(50,80),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            RestService restService = new RestService();
                            restService.createPlaylist(_playlistName).then((value) {
                              if (value != -1) {
                                Navigator.of(context).pop();
                              }
                              else {

                              }
                            });
                          },
                          child: Text('Create'),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}