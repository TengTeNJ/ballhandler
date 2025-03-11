import 'package:code/models/airbattle/my_pucks_model.dart';
import 'package:code/views/airbattle/airbattle_my_pucks_view.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class AirbattleMyPucksListView extends StatefulWidget {
  List<MyPucksModel>? datas;

  AirbattleMyPucksListView({super.key, this.datas});

  @override
  State<AirbattleMyPucksListView> createState() =>
      _AirbattleMyPucksListViewState();
}

class _AirbattleMyPucksListViewState extends State<AirbattleMyPucksListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(), // 禁止滑动
        shrinkWrap: true, // ListView 的 shrinkWrap 属性设置为 true，可以让 ListView 根据其内容的实际高度来调整自身大小，而不是无限扩展
        itemBuilder: (context, index) {
          return AirbattleMyPucksView(model: MyPucksModel());
        },
        separatorBuilder: (context, index) {
          return Container(
              height: 1,
              decoration: BoxDecoration(
                  color: hexStringToColor('#565674'),
                  borderRadius: BorderRadius.circular(1)));
        },
        itemCount: 4);
  }
}
