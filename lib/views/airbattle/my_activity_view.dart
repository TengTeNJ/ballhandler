import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/base_image.dart';
import 'package:flutter/material.dart';
class MyActivityDataView extends StatefulWidget {
  MyActivityModel  activityModel;
  MyActivityDataView({required this.activityModel});

  @override
  State<MyActivityDataView> createState() => _MyActivityDataViewState();
}

class _MyActivityDataViewState extends State<MyActivityDataView> {
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
              visible: widget.activityModel.trainVideo.contains('http'),
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
                  TTNetImage(url: widget.activityModel.activityIcon, placeHolderPath: 'images/airbattle/gold.png', width: 48, height: 48),
                  SizedBox(width: 16,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Constants.customTextWidget(widget.activityModel.activityName, 14, '#B1B1B1'),
                          SizedBox(width: 16,),
                          Constants.regularWhiteTextWidget(widget.activityModel.startDate, 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.rankNumber, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Rank', 12, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.trainScore, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Score', 12, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.avgPace, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Avg.pace', 12, '#B1B1B1'),
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
