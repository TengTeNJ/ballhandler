import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/airbattle_rank_view.dart';
import 'package:flutter/material.dart';
class AirbattleListView extends StatefulWidget {
  const AirbattleListView({super.key});

  @override
  State<AirbattleListView> createState() => _AirbattleListViewState();
}

class _AirbattleListViewState extends State<AirbattleListView> {
  ScrollController _scrollController = ScrollController();
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
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
      padding: EdgeInsets.only(top: 26),
      decoration: BoxDecoration(
        color: hexStringToColor('#3E3E55'),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListView.separated(
          controller: _scrollController,
          itemBuilder: (context, index) {
            return AirbattleRankView();
          },
          separatorBuilder: (context, index) => SizedBox(
            height: 16,
          ),
          itemCount: 10),
    );
  }
}
