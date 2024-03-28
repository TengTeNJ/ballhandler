import 'package:code/views/airbattle/activity_view.dart';
import 'package:flutter/material.dart';
import '../../models/airbattle/activity_model.dart';

typedef IntFunction = void Function(ActivityModel);

class ActivityListView extends StatefulWidget {
  List<ActivityModel> datas = [];
  IntFunction selectItem;

  ActivityListView({required this.datas, required this.selectItem});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print('-----');
              widget.selectItem(widget.datas[index]);
            },
            child: ActivityView(
              activityModel: widget.datas[index],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: widget.datas.length);
  }
}
