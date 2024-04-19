import 'package:code/services/http/rank.dart';
import 'package:code/views/airbattle/my_stats_grid_view.dart';
import 'package:flutter/material.dart';

class MyStatsGridListView extends StatefulWidget {
  AnalyzeDataModel model;
  int selectType;

  MyStatsGridListView({required this.model, required this.selectType});

  @override
  State<MyStatsGridListView> createState() => _MyStatsGridListViewState();
}

class _MyStatsGridListViewState extends State<MyStatsGridListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyStatsGridView(
              index: 0,
              value: widget.model.avgPace.toString(),
              comparevalue: widget.model.avgPaceCompared,
              riseUp: widget.model.avgRise,
              selectType: widget.selectType,
            ),
            SizedBox(
              width: 8,
            ),
            MyStatsGridView(
              index: 1,
              value: widget.model.trainScore.toString(),
              comparevalue: widget.model.scoreCompared,
              riseUp: widget.model.scoreRise,
              selectType: widget.selectType,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyStatsGridView(
              index: 2,
              value: widget.model.trainTime.toString(),
              comparevalue: widget.model.timeCompared,
              riseUp: widget.model.timeRise,
              selectType: widget.selectType,
            ),
            SizedBox(
              width: 8,
            ),
            MyStatsGridView(
              index: 3,
              value: widget.model.trainCount.toString(),
              comparevalue: widget.model.countCompared,
              riseUp: widget.model.countRise,
              selectType: widget.selectType,
            ),
          ],
        ),
      ],
    );
    ;
  }
}
