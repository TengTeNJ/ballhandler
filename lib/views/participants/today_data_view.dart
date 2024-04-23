import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../utils/navigator_util.dart';

class TodayDataView extends StatefulWidget {
  GameOverModel  gameOverModel;
   TodayDataView({required this.gameOverModel});

  @override
  State<TodayDataView> createState() => _TodayDataViewState();
}

class _TodayDataViewState extends State<TodayDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
        color: hexStringToColor('#3E3E55'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          (widget.gameOverModel.videoPath.length > 0 && widget.gameOverModel.videoPath.contains('http')) ? Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  NavigatorUtil.push('videoPlay', arguments: {
                    "model": widget.gameOverModel,
                    "gameFinish": false
                  });
                },
                child: Container(
                  width: 34,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Constants.baseStyleColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Constants.regularWhiteTextWidget('VIEW', 10),
                  ),
                ),
              )) :Container(),
          Positioned(
              top: 12,
              bottom: 12,
              left: 16,
              right: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                      image: AssetImage('images/participants/icon_orange.png'),
                      width: 48,
                      height: 48,
                      fit: BoxFit.fill
                  ),
                  SizedBox(width: 16,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Constants.customTextWidget('Training Mode', 14, '#B1B1B1'),
                          Constants.regularWhiteTextWidget(widget.gameOverModel.endTime, 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.gameOverModel.avgPace, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Avg.pace (sec.)', 10, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.gameOverModel.score, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Score(pts.)', 10, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget('00:' + widget.gameOverModel.time, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Time(sec.)', 10, '#B1B1B1'),
                            ],
                          )
                        ],
                      )
                    ],
                  ))
                ],
              )),
        ],
      ),
    );
  }
}
