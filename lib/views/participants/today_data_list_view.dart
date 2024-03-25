import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';
class TodayDataListView extends StatefulWidget {
  const TodayDataListView({super.key});

  @override
  State<TodayDataListView> createState() => _TodayDataListViewState();
}

class _TodayDataListViewState extends State<TodayDataListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,index){
      return TodayDataView();
    }, separatorBuilder: (context,index)=> SizedBox(height: 12,), itemCount: 10);
  }
}
