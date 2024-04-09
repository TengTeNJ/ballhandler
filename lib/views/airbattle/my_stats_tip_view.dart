import 'package:code/constants/constants.dart';
import 'package:code/models/mystats/my_stats_model.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class MyStatsTipView extends StatefulWidget {
  MyStatsModel dataModel;
  MyStatsTipView({required this.dataModel});

  @override
  State<MyStatsTipView> createState() => _MyStatsTipViewState();
}

class _MyStatsTipViewState extends State<MyStatsTipView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: hexStringToColor('#3E3E55')),
      width: 90,
      height: 90,
      child: Padding(
        padding: EdgeInsets.only(left: 4,right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Constants.boldBaseTextWidget(widget.dataModel.speed.toString(), 24,height: 0.8),
                Constants.mediumBaseTextWidget('Point/s', 10),
              ],
            ),
            Constants.customTextWidget('Rank '+ widget.dataModel.rank, 10, '#B1B1B1'),
            Constants.customTextWidget( widget.dataModel.gameTimer, 10, '#B1B1B1'),
            Constants.customTextWidget( widget.dataModel.trainingMode, 10, '#B1B1B1'),
          ],
        ),
      ),
    );
  }
}
