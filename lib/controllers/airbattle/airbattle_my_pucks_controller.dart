import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/airbattle_my_pucks_list_view.dart';
import 'package:code/views/airbattle/heatmap_container_view.dart';
import 'package:code/views/participants/today_data_view.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../widgets/navigation/CustomAppBar.dart';

class AirbattleMyPucksController extends StatefulWidget {
  int monthDay; // 月份
  int startDayIndex;
  AirbattleMyPucksController({super.key,required this.monthDay, this.startDayIndex = 1});

  @override
  State<AirbattleMyPucksController> createState() =>
      _AirbattleMyPucksControllerState();
}

class _AirbattleMyPucksControllerState
    extends State<AirbattleMyPucksController> {
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
              Constants.boldWhiteTextWidget('My Pucks', 30),
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
                          Constants.mediumWhiteTextWidget('100', 40),
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
              SizedBox(height: 24,),
              HeatMapContainerView(monthDay: widget.monthDay,startDayIndex: widget.startDayIndex,),
              SizedBox(height: 12,),
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: hexStringToColor('#565674'),
                    borderRadius: BorderRadius.circular(1)
                ),
              ),
              // 在 Row 中使用 Expanded 或 Flexible 包裹 Text 组件，让 Text 组件能够获取剩余的空间并根据需要换行。示例代码如下：
              SizedBox(height: 36,),
              Constants.regularWhiteTextWidget('Activity Record', 16),
              AirbattleMyPucksListView(),
              Container(
                height: 1,
                decoration: BoxDecoration(
                    color: hexStringToColor('#565674'),
                    borderRadius: BorderRadius.circular(1)
                ),
              ),
              SizedBox(height: 36,),
              Constants.mediumWhiteTextWidget('My Top 5', 16),
              SizedBox(height: 16,),
              TodayDataView(gameOverModel: GameOverModel(),isAirbattle: true,),
              SizedBox(height: 36,)
            ],

          ),
        ),
      ),
    );
  }
}
