import 'package:code/services/http/rank.dart';
import 'package:code/views/ranking/ranking_item_view.dart';
import 'package:flutter/material.dart';

class RankingListView extends StatefulWidget {
  List<RankModel> datas;
  Function? loadMore;
  RankingListView({required this.datas,this.loadMore});

  @override
  State<RankingListView> createState() => _RankingListViewState();
}

class _RankingListViewState extends State<RankingListView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('上拉加载---');
      if(widget.loadMore != null){
        widget.loadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
        itemBuilder: (context, index) {
          return RankingItemView(model: widget.datas[index],);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: widget.datas.length);
  }
}
