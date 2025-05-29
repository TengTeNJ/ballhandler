import 'package:code/models/airbattle/heatmap_model.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/airbattle/airbattle_my_pucks_list_view.dart';
import 'package:code/views/airbattle/heatmap_container_view.dart';
import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/airbattle/my_airbattle_pucks_model.dart';
import '../../services/http/airbattle.dart';
import '../../widgets/navigation/CustomAppBar.dart';

class AirbattleMyPucksController extends StatefulWidget {
  int monthDay; // 月份
  int startDayIndex;
  MyAirBattlePucksModel? pucksModel;
  String? startTime;
  String? endTime;
  String? activityId;
  AirbattleMyPucksController(
      {super.key,
      required this.monthDay,
      this.startDayIndex = 1,
      this.pucksModel,
        this.activityId,
        this.startTime,
        this.endTime
      });

  @override
  State<AirbattleMyPucksController> createState() =>
      _AirbattleMyPucksControllerState();
}

class _AirbattleMyPucksControllerState
    extends State<AirbattleMyPucksController> {
  bool _crossMonth = false;
  List<HeatMapDataModel> _heatMapDats = [];
  String _raiseRange = '-';
  queryHeatMapDate() async{
    // if(widget.startTime.length)
    DateTime _startDate = StringUtil.stringToDate(widget.startTime.toString());
    DateTime _endDate = StringUtil.stringToDate(widget.endTime.toString());
    if(_startDate.month != _endDate.month){
      _crossMonth = true;
    }

    final _response =  await AirBattle.queryAirBattleHetMapData(widget.activityId.toString(), widget.startTime.toString(), widget.endTime.toString());
   if(_response.success && _response.data != null){
     _raiseRange = _response.data!.raiseRange;
     if(_response.data!.datas != null){
       _heatMapDats.addAll(_response.data!.datas);
       if(mounted){
         setState(() {

         });
       }
     }
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryHeatMapDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Constants.boldWhiteTextWidget('My Journey', 30),
              SizedBox(
                height: 48,
              ),
              Row(
                children: [
                  Image(
                    image: AssetImage('images/airbattle/airbattle.png'),
                    height: 72,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    width: 34,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constants.mediumWhiteTextWidget(
                          widget.pucksModel?.trainIntegral ?? '0', 40),
                      SizedBox(
                        height: 8,
                      ),
                      Constants.regularGreyTextWidget(
                          'You can redeem prizes with the pucks you have earned.',
                          14,
                          textAlign: TextAlign.start,
                          height: 1.3)
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: 24,
              ),
              HeatMapContainerView(
                crossMonth: _crossMonth,
                heatMapDats: _heatMapDats,
                monthDay: widget.monthDay,
                startDayIndex: widget.startDayIndex,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: hexStringToColor('#565674'),
                    borderRadius: BorderRadius.circular(1)),
              ),
              // 在 Row 中使用 Expanded 或 Flexible 包裹 Text 组件，让 Text 组件能够获取剩余的空间并根据需要换行。示例代码如下：
              SizedBox(
                height: 36,
              ),
              Constants.regularWhiteTextWidget('Activity Record', 16),
              AirbattleMyPucksListView(
                raiseRange: _raiseRange,
                pucksModel:widget.pucksModel
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: hexStringToColor('#565674'),
                    borderRadius: BorderRadius.circular(1)),
              ),
              SizedBox(
                height: 36,
              ),
              Constants.mediumWhiteTextWidget('My Top 5', 16),
              SizedBox(
                height: 16,
              ),
              widget.pucksModel != null ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TodayDataView(
                      gameOverModel:widget.pucksModel!.datas[index],
                      isAirbattle: true,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 12,
                      ),
                  itemCount: widget.pucksModel!.datas.length) : Container(),
              SizedBox(
                height: 36,
              )
            ],
          ),
        ),
      ),
    );
  }
}
