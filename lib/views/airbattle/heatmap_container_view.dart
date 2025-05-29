import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/heatmap_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/airbattle/heat_map_cross_view.dart';
import 'package:code/views/airbattle/heat_map_view.dart';
import 'package:flutter/material.dart';

class HeatMapContainerView extends StatefulWidget {
  int monthDay; // 月份
  int startDayIndex;
  List<HeatMapDataModel> heatMapDats;
  bool crossMonth;
  HeatMapContainerView({super.key,required this.monthDay, required this.heatMapDats, this.startDayIndex = 1,this.crossMonth = false});

  @override
  State<HeatMapContainerView> createState() => _HeatMapContainerViewState();
}

class _HeatMapContainerViewState extends State<HeatMapContainerView> {
  int _begainIndex = 0; // 如果是跨月的话 计算跨月的所在的列的索引
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('${widget.monthDay}---${widget.startDayIndex}');
    // 跨月才需要月份按照计算后显示在不同的位置
    if(widget.crossMonth){
      calcuteCrossMonthIndex();
    }
  }
  calcuteCrossMonthIndex(){
    bool _has31 = [1,3,5,7,8,10,12].contains(widget.monthDay);
    int _differenceCount = ((_has31 ? 31 : 30) - widget.startDayIndex + 1);
    // _differenceCount + 2是因为跨月的竖列排的话 从第一列最后一个开始 一列有3个
    _begainIndex = ((_differenceCount + 2) / 3).toInt();
    if(((_differenceCount + 2) % 3) != 0){
      _begainIndex += 1;
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
          ),
          Constants.boldWhiteTextWidget('Days Active', 16),
          SizedBox(
            width: 22,
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Row(
               children: [
                 SizedBox(width: widget.crossMonth ?(_begainIndex*20 - 5) : 0),
                 widget.crossMonth ? Container(
                   width: 20,
                   child:  Center(child: Constants.mediumWhiteTextWidget(StringUtil.monthToAbbreviation( widget.monthDay + 1 ), 10,height: 2.5),)
                   ,
                 ) : Constants.mediumWhiteTextWidget(StringUtil.monthToAbbreviation(widget.monthDay), 10,height: 2.5),
               ],
             ),
              widget.crossMonth ?  HeatMapCrossView(
                heatMapDats: widget.heatMapDats,
                monthDay: widget.monthDay + 1,
                startDayIndex: widget.startDayIndex,
              ) : HeatMapView(
                heatMapDats: widget.heatMapDats,
                monthDay: widget.monthDay,
                startDayIndex: widget.startDayIndex,
              ),
              SizedBox(height: 16,),
            ],
          )),
          SizedBox(
            width: 32,
          ),
        ],
      ),
    );
  }
}
