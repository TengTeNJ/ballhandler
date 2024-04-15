import 'package:code/services/http/profile.dart';
import 'package:code/views/profile/profile_grid_view.dart';
import 'package:flutter/material.dart';
class ProfileGridListView extends StatefulWidget {
  MyAccountDataModel model;
   ProfileGridListView({required this.model});

  @override
  State<ProfileGridListView> createState() => _ProfileGridListViewState();
}

class _ProfileGridListViewState extends State<ProfileGridListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileGridView(assetPath: 'images/profile/time.png',title: widget.model.avgPace.toString(),unit: 'Sec',des: 'Best React Time',),
            ProfileGridView(assetPath: 'images/profile/score.png',title: widget.model.trainScore.toString() ,unit: 'Pts',des: 'Total Score',),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileGridView(assetPath: 'images/profile/training.png',title: (widget.model.trainTime/60).toStringAsFixed(2) ,unit: 'Pts',des: 'Time on Trainings',),
            ProfileGridView(assetPath: 'images/profile/home.png',title: widget.model.trainCount.toString() ,unit: '',des: 'Trainings',),
          ],
        ),
      ],
    );
  }
}
