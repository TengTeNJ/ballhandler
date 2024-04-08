import 'package:code/models/airbattle/award_model.dart';
import 'package:code/views/airbattle/my_award_view.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class AwardListView extends StatefulWidget {
  List<AwardModel> datas;
  Function? selectItem;

  AwardListView({required this.datas, this.selectItem});

  @override
  State<AwardListView> createState() => _AwardListViewState();
}

class _AwardListViewState extends State<AwardListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          // MyAwardView(model: widget.datas[index])
          // return Container(color: Colors.red,);
          return GestureDetector(
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
