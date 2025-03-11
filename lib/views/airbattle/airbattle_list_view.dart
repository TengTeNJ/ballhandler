import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/airbattle_rank_view.dart';
import 'package:flutter/material.dart';

import '../../services/http/rank.dart';
class AirbattleListView extends StatefulWidget {
  int activityId;
  AirbattleListView({super.key,required this.activityId});

  @override
  State<AirbattleListView> createState() => _AirbattleListViewState();
}

class _AirbattleListViewState extends State<AirbattleListView> {
  ScrollController _scrollController = ScrollController();
  List<RankModel> _currentDatas = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    queryRankData();
  }

  // 请求活动的排名数据
  queryRankData() async{
    print('queryRankData ==');
   if(widget.activityId == 0){
     return;
   }
   final  _datas = await AirBattle.queryIAirBattleRankData(widget.activityId);
   if(_datas != null &&_datas.data!.isNotEmpty){
     _currentDatas.addAll(_datas.data![0]);
     setState(() {

     });
   }
  }
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      // if(widget.loadMore != null){
      //   widget.loadMore!();
      // }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26 + _currentDatas.length*64,
      padding: EdgeInsets.only(top: 26),
      decoration: BoxDecoration(
        color: hexStringToColor('#3E3E55'),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            return AirbattleRankView(model: _currentDatas[index],);
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 16,
          ),
          itemCount: _currentDatas.length),
    );
  }
}
