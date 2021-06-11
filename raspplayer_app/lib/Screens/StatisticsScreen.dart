import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/StatisticList.dart';
import 'package:raspplayer_app/Services/RestService.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {

  List<StatisticList> statisticList = [];

  @override
  void initState() {
    super.initState();
    RestService rs = new RestService();
    rs.getStatistic().then((result) {
      setState(() {
        statisticList = <StatisticList>[
          StatisticList(
            statisticName: "Best DJ",
            statisticValue: result["bestDj"]["username"],
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: result["bestDj"]["likes"].toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontSize: 11,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Color.fromARGB(255, 128, 128, 128),
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          StatisticList(
            statisticName: 'Best Song',
            statisticValue: result["bestSong"]["songname"],
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: result["bestSong"]["likes"].toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontSize: 11,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Color.fromARGB(255, 128, 128, 128),
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          StatisticList(
            statisticName: 'Favorite Artist',
            statisticValue: result["favArtist"]["artistname"],
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: result["favArtist"]["likes"].toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontSize: 11,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Color.fromARGB(255, 128, 128, 128),
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          StatisticList(
            statisticName: 'Playlist Junkie',
            statisticValue: result["playlistJunkie"]["username"],
            child: Text(
              '${result["playlistJunkie"]["songsAdded"]} Songs added',
              style: TextStyle(
                color: Color.fromARGB(255, 128, 128, 128),
                fontSize: 11,
              ),
            ),
          ),

          StatisticList(
            statisticName: 'Most Replays',
            statisticValue: result["mostReplays"]["songname"],
            child: Text(
              'replayed ${result["mostReplays"]["replays"]} times',
              style: TextStyle(
                color: Color.fromARGB(255, 128, 128, 128),
                fontSize: 11,
              ),
            ),
          ),

          StatisticList(
            statisticName: 'Most Skipped',
            statisticValue: result["mostSkipped"]["songname"],
            child: Text(
              'skipped ${result["mostSkipped"]["skipped"]} times',
              style: TextStyle(
                color: Color.fromARGB(255, 128, 128, 128),
                fontSize: 11,
              ),
            ),
          ),

        ];
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      drawer: NavigationDrawer(),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: statisticList,
        ),
      ),
    );
  }

}
