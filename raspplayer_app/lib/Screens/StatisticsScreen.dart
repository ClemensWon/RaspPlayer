import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raspplayer_app/Components/NavigationDrawer.dart';
import 'package:raspplayer_app/Components/StatisticList.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  final List<StatisticList> statisticList = <StatisticList>[
    StatisticList(
      statisticName: 'Best DJ',
      statisticValue: 'DJ Ötzi',
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '420',
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
      statisticValue: 'Song1',
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '69',
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
      statisticValue: 'Mozart',
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '123',
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
      statisticValue: 'MoneyBoy',
      child: Text(
              '${123} Songs added',
              style: TextStyle(
                color: Color.fromARGB(255, 128, 128, 128),
                fontSize: 11,
              ),
        ),
    ),

    StatisticList(
      statisticName: 'Most Replays',
      statisticValue: 'Song24',
      child: Text(
        'replayed ${5} times',
        style: TextStyle(
          color: Color.fromARGB(255, 128, 128, 128),
          fontSize: 11,
        ),
      ),
    ),

    StatisticList(
      statisticName: 'Most Skipped',
      statisticValue: 'Song99',
      child: Text(
        'skipped ${19} times',
        style: TextStyle(
          color: Color.fromARGB(255, 128, 128, 128),
          fontSize: 11,
        ),
      ),
    ),
  ];

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
