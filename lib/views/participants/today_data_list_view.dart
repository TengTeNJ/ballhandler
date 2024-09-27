import 'package:code/models/game/game_over_model.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';
import '../../services/http/airbattle.dart';

class TodayDataListView extends StatefulWidget {
  List<GameOverModel> datas;
  Function? loadMore;
  TodayDataListView({required this.datas, this.loadMore});

  @override
  State<TodayDataListView> createState() => _TodayDataListViewState();
}

class _TodayDataListViewState extends State<TodayDataListView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if (widget.loadMore != null) {
        widget.loadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.datas.length == 0
        ? NoDataView()
        : ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              return TodayDataView(
                gameOverModel: widget.datas[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 12,
                ),
            itemCount: widget.datas.length);
  }
}
