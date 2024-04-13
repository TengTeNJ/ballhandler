import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

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
          Visibility(
            visible: widget.gameOverModel.videoPath.length > 0,
             replacement: Container(),
              child: Positioned(
              top: 8,
              right: 8,
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
              ))),
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
                              Constants.customTextWidget('Avg.pace (sec.)', 8, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.gameOverModel.score, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Score(pts.)', 8, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.gameOverModel.time, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Time(min.)', 8, '#B1B1B1'),
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
