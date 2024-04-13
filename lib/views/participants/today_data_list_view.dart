import 'package:code/models/game/game_over_model.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';
import '../../services/http/airbattle.dart';
class TodayDataListView extends StatefulWidget {
  List<GameOverModel>datas;
  TodayDataListView({required this.datas});

  @override
  State<TodayDataListView> createState() => _TodayDataListViewState();
}

class _TodayDataListViewState extends State<TodayDataListView> {
  @override
  Widget build(BuildContext context) {
    return  widget.datas.length == 0 ? NoDataView():ListView.separated(itemBuilder: (context,index){
      return TodayDataView(gameOverModel: widget.datas[index],);
    }, separatorBuilder: (context,index)=> SizedBox(height: 12,), itemCount: widget.datas.length);
  }
}
