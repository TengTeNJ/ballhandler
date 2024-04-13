import 'package:code/views/airbattle/my_activity_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';
import '../../services/http/airbattle.dart';
class MyActivityListView extends StatefulWidget {
  List<MyActivityModel>datas;
  MyActivityListView({required this.datas});

  @override
  State<MyActivityListView> createState() => _MyActivityListViewState();
}

class _MyActivityListViewState extends State<MyActivityListView> {
  @override
  Widget build(BuildContext context) {
    return  widget.datas.length == 0 ? NoDataView():ListView.separated(itemBuilder: (context,index){
      return MyActivityDataView(activityModel: widget.datas[index],);
    }, separatorBuilder: (context,index)=> SizedBox(height: 12,), itemCount: widget.datas.length);
  }
}
