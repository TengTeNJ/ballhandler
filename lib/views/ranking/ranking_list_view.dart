import 'package:code/views/ranking/ranking_item_view.dart';
import 'package:flutter/material.dart';

class RankingListView extends StatefulWidget {
  const RankingListView({super.key});

  @override
  State<RankingListView> createState() => _RankingListViewState();
}

class _RankingListViewState extends State<RankingListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return RankingItemView();
        },
        separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
        itemCount: 10);
  }
}
