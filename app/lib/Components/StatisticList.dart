import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticList extends StatelessWidget {
  //name of the statistic property
  final String statisticName;
  //value of the statistic property
  final String statisticValue;
  final Widget child;
  static const Widget defaultChild = Text('no data');

  StatisticList({this.statisticName, this.statisticValue = 'not available', this.child = defaultChild});

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox.fromSize(
              size: Size(130,36),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  statisticName + ':',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(130,36),
              child: Align(
                alignment: Alignment.center,
                child: Column(

                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        statisticValue,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: child
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}