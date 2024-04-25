import 'package:code/models/airbattle/award_model.dart';
import 'package:code/views/airbattle/my_award_view.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class AwardListView extends StatefulWidget {
  List<AwardModel> datas;
  Function? loadMore;
  Function? selectItem;

  AwardListView({required this.datas, this.selectItem,this.loadMore});

  @override
  State<AwardListView> createState() => _AwardListViewState();
}

class _AwardListViewState extends State<AwardListView> {
  ScrollController _scrollController = ScrollController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('我的奖励上拉加载---');
      if(widget.loadMore != null){
        widget.loadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.datas.length == 0 ? NoDataView() : ListView.separated(
      controller: _scrollController,
        itemBuilder: (context, index) {
          // MyAwardView(model: widget.datas[index])
          // return Container(color: Colors.red,);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (widget.selectItem != null) {
                widget.selectItem!(widget.datas[index]);
              }
            },
            child: MyAwardView(model: widget.datas[index]),
          );
        },
        separatorBuilder: (context, index) => Container(
          height: 0,
          color: hexStringToColor('#565674'),
        ),
        itemCount: widget.datas.length);
  }
}
