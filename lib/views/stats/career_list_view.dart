import 'package:code/views/stats/career_item_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';
class CareerListView extends StatelessWidget {
  int score;
  CareerListView({super.key, required this.score});


  @override
  Widget build(BuildContext context) {
    int count = 4;
    int unlocked = (score/500.0).floor();
    count = max(count, (score/500.0).ceil());
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (context,index){
        return const SizedBox(height: 42,);
      },
      itemBuilder: (context,index){
        return CareerItemView(unlocked: unlocked >= (index + 1) ? true : false,score: 500 * (index + 1),);
      },
    );
  }
}
