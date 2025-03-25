import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../models/airbattle/my_airbattle_pucks_model.dart';

class AirbattleInfoCardView extends StatefulWidget {
  Gradient gradient;
  String title;
  int value;
  String des;
  String imageName;
  int monthDay; // 月份
  int startDayIndex;
  MyAirBattlePucksModel? pucksModel;
  String? startTime;
  String? endTime;
  String? activityId;
  AirbattleInfoCardView(
      {super.key,
      required this.monthDay,
      this.startDayIndex = 0,
      this.gradient = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(19, 107, 146, 1.0),
          Color.fromRGBO(20, 29, 154, 1.0)
        ],
      ),
      required this.title,
      required this.value,
      required this.imageName,
      required this.des,
      this.pucksModel,
      this.startTime,
      this.endTime,
        this.activityId
      });

  @override
  State<AirbattleInfoCardView> createState() => _AirbattleInfoCardViewState();
}

class _AirbattleInfoCardViewState extends State<AirbattleInfoCardView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.title == 'Awards') {
          NavigatorUtil.push(Routes.airbattleawards);
        } else {
          NavigatorUtil.push(Routes.mypucks, arguments: {
            "day": widget.startDayIndex,
            "month": widget.monthDay,
            'model': widget.pucksModel,
            'id':widget.activityId,
            'start':widget.startTime,
            'end':widget.endTime
          });
        }
      },
      child: Container(
        width: 165,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), gradient: widget.gradient),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.mediumWhiteTextWidget(widget.title, 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.title == 'Awards'
                            ? Container()
                            : Constants.mediumWhiteTextWidget(
                                widget.value.toString(), 40),
                        Constants.regularWhiteTextWidget(
                            widget.des.toString(), 14),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Image(
                  image: AssetImage('images/airbattle/${widget.imageName}.png'),
                  width: 65,
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
