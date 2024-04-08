import 'package:code/services/http/rank.dart';
import 'package:code/views/ranking/ranking_item_view.dart';
import 'package:flutter/material.dart';

class RankingListView extends StatefulWidget {
  List<RankModel> datas;
   RankingListView({required this.datas});

  @override
  State<RankingListView> createState() => _RankingListViewState();
}

class _RankingListViewState extends State<RankingListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return RankingItemView(model: widget.datas[index],);
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: widget.datas.length);
  }
}
