import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:flutter/foundation.dart';
import 'package:raspplayer_app/Services/RestService.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';


class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryScreenSate();
}

class LibraryScreenSate extends State<LibraryScreen> {
  final List<SongListItem> songList = [];
  bool _stuff = true;

  @override
  void initState() {
    super.initState();
    RestService restService = new RestService();
    restService.getSongs().then((songs) => {
      setState((){
        songs.forEach((song) {
          songList.add(SongListItem.fromSong(key: Key(song.id.toString()), song: song, child: StatefulBuilder( builder:  (BuildContext context, StateSetter setState) {
            return Checkbox(
                key: Key(song.id.toString() + "_checkbox"),
                value: _stuff,
                onChanged: (changeValue) {
                  setState(() {
                    _stuff = changeValue;
                  });
                });
          }),
          ));
          //stderr.writeln(song.id);
        });
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('Music Library'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        margin:EdgeInsets.all(10),
        child: ReorderableListView(
          header: TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              focusColor: Color.fromRGBO(0, 1, 49, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final SongListItem item = songList.removeAt(oldIndex);
              songList.insert(newIndex, item);
            });
          },
          children: songList,
        ),
      ),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: SizedBox(
                  width: 50,
                  child:Text(
                    "Add",
                    textAlign: TextAlign.center,
                  )
                ),
                onPressed: () {
                  //...
                },
                
              ),
              ElevatedButton(
                child: SizedBox(
                    width: 50,
                    child:Text(
                      "Upload",
                      textAlign: TextAlign.center,
                    )
                ),
                onPressed: () {

                },
              ),
              Checkbox(
                value: _stuff,
                onChanged: (changeValue){
                  setState(() {
                    _stuff = changeValue;
                    stderr.writeln(_stuff);
                  });

                },
              )
            ]
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
