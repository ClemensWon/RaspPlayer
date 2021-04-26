import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/SongListItem.dart';
import 'package:flutter/foundation.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryScreenSate();
}

class LibraryScreenSate extends State<LibraryScreen> {
  final List<SongListItem> songList = <SongListItem>[
    SongListItem(
      key: Key('0 song'),
      songTitle: '0 Song',
      artist: 'Mozart',
      username: 'Clemens',
      child: Checkbox(
        value: false,
        onChanged: (bool check) {

        },
      ),
    ),
    SongListItem(
      key: Key('1 song'),
      songTitle: '1 Song',
      artist: 'Mozart',
      username: 'Clemens',
      child: Checkbox(
        value: false,
        onChanged: (bool check) {

        },
      ),
    ),
  ];

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
              )
            ]
        )
    );
  }
}
