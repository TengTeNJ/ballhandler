import 'package:code/views/airbattle/activity_view.dart';
import 'package:flutter/material.dart';
import '../../models/airbattle/activity_model.dart';

class ActivityListView extends StatefulWidget {
  List<ActivityModel> datas = [];

  ActivityListView({required this.datas});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ActivityView(activityModel: widget.datas[index],);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: widget.datas.length);
  }
}
