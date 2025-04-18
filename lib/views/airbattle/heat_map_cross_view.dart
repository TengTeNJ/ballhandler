import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../models/airbattle/heatmap_model.dart';
class HeatMapCrossView extends StatefulWidget {
  int monthDay; // 月份
  int startDayIndex; // 起始日期的索引 也是每个月的哪一日
  List<HeatMapDataModel> heatMapDats;
  HeatMapCrossView({super.key, required this.heatMapDats, required this.monthDay, this.startDayIndex = 1,});

  @override
  State<HeatMapCrossView> createState() => _HeatMapCrossViewState();
}

class _HeatMapCrossViewState extends State<HeatMapCrossView> {
  bool _has31Days = false; // 当月会否有31天
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if([1,3,5,7,8,10,12].contains(widget.monthDay)){
      _has31Days = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 190,
      child: Wrap(
        direction: Axis.vertical,
        spacing: 10.0, // 主轴方向上的间距
        runSpacing: 10.0, // 交叉轴方向上的间距
        children: List.generate(30, (index){
          Color color = hexStringToColor('#B1B1B1'); // 默认灰色
          if(index >=2 && index <= ( widget.heatMapDats.length - 1 + 2)){
            HeatMapStatu statu = widget.heatMapDats[index - 2].statu;
            switch (statu){
              case HeatMapStatu.Primary:
                color = hexStringToColor('#FBBA00');
                break;
              case HeatMapStatu.Zero:
                color = hexStringToColor('#B1B1B1');
                break;
              case HeatMapStatu.Middle:
                color = hexStringToColor('#F8850B');
                break;
              case HeatMapStatu.Active:
                color = hexStringToColor('#F84C0B');
                break;
            }
          }
          return Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5)
            ),
          );
        }),
      ),
    );
  }
}
