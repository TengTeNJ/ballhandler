import 'package:code/services/http/airbattle.dart';
import 'package:code/views/airbattle/activity_view.dart';
import 'package:flutter/material.dart';

typedef IntFunction = void Function(ActivityModel);

class ActivityListView extends StatefulWidget {
  IntFunction selectItem;

  ActivityListView({required this.selectItem});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  List<ActivityModel> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryActivityListData();
  }
  queryActivityListData()async{
    final _response = await AirBattle.queryAllActivityListData(1);
    if(_response.success && _response.data != null){
      _datas.addAll(_response.data!);
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              widget.selectItem(_datas[index]);
            },
            child: ActivityView(
              activityModel: _datas[index],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: _datas.length);
  }
}
