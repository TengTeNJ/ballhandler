import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/airbattle_rank_view.dart';
import 'package:flutter/material.dart';

import '../../services/http/rank.dart';
import '../../utils/notification_bloc.dart';
import '../base/no_data_view.dart';

class AirbattleListView extends StatefulWidget {
  int activityId;

  AirbattleListView({super.key, required this.activityId});

  @override
  State<AirbattleListView> createState() => _AirbattleListViewState();
}

class _AirbattleListViewState extends State<AirbattleListView> {
  ScrollController _scrollController = ScrollController();
  List<RankModel> _currentDatas = [];
  late StreamSubscription subscription;
  int _rankType = 1;

  void initState() {
    // TODO: implement initState
    super.initState();
    // 页面滑动监听
    _scrollController.addListener(_scrollListener);
    // 数据请求
    queryRankData();
    // 切换tab监听
    subscription = EventBus().stream.listen((event) {
      if (event is String && event.contains(kAirBattleTabSelect)) {
        String eventString = event as String;
        String rankType =
            eventString.substring(eventString.length - 1, eventString.length);
        _rankType = int.parse(rankType);
        queryRankData();
      }else if(event is String && event == kBackFromFinish){
        // 游戏完成返回后重新刷新页面
        queryRankData();
      }
    });
  }

  // 请求活动的排名数据
  queryRankData() async {
    if (widget.activityId == 0) {
      return;
    }
    final _apiResponse = await AirBattle.queryIAirBattleRankDataBaseType(
        widget.activityId,
        rankType: _rankType);
    // 请求成功 则清空缓存数据
    if (_apiResponse.success) {
      _currentDatas.clear();
      _currentDatas.addAll(_apiResponse.data!.data);
      if(mounted){
        setState(() {});
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      // if(widget.loadMore != null){
      //   widget.loadMore!();
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _currentDatas.isNotEmpty
        ? Container(
            height: 26 + _currentDatas.length * 48 + 16*(_currentDatas.length - 1) + 26,
            padding: EdgeInsets.only(top: 26,bottom: 26),
            decoration: BoxDecoration(
                color: hexStringToColor('#3E3E55'),
                borderRadius: BorderRadius.circular(10)),
            child: ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return AirbattleRankView(
                    model: _currentDatas[index],
                    rank: index + 1,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 16,
                    ),
                itemCount: _currentDatas.length),
          )
        : NoDataView();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}
