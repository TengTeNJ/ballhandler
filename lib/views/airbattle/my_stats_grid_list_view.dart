import 'package:code/views/airbattle/my_stats_grid_view.dart';
import 'package:flutter/material.dart';


class MyStatsGridListView extends StatefulWidget {
  const MyStatsGridListView({super.key});

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
            MyStatsGridView(),
            SizedBox(width: 8,),
            MyStatsGridView(),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyStatsGridView(),
            SizedBox(width: 8,),
            MyStatsGridView(),
          ],
        ),
      ],
    );;
  }
}
