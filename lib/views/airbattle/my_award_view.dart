import 'package:code/constants/constants.dart';
import 'package:code/models/airbattle/award_model.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class MyAwardView extends StatefulWidget {
  AwardModel model;
  MyAwardView({required this.model});

  @override
  State<MyAwardView> createState() => _MyAwardViewState();
}

class _MyAwardViewState extends State<MyAwardView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Constants.mediumWhiteTextWidget(widget.model.title, 14),
                      SizedBox(
                        width: 16,
                      ),
                      StatuView(widget.model)
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Constants.customTextWidget(widget.model.des, 14, '#B1B1B1'),
                  SizedBox(
                    height: 4,
                  ),
                  Constants.customTextWidget(
                      widget.model.airbattleTitle + '   ' + widget.model.showTime,
                      14,
                      '#B1B1B1')
                ],
              ),
              Image(
                image: AssetImage('images/airbattle/next_white.png'),
                width: 7.5,
                height: 14,
              )
            ],
          ),
          SizedBox(height: 12,),
          Container(
            height: 0.5,
            color: hexStringToColor('#565674'),
          )
        ],
      ),
    );
  }
}

Widget StatuView(AwardModel model) {
  if (model.statuString == 'No Viewed') {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: hexStringToColor('#3E3E55')),
      child: Constants.customTextWidget('No Viewed', 10, '#B6F61D'),
    );
  } else if (model.statuString == 'Viewed') {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: hexStringToColor('#3E3E55')),
      child: Constants.customTextWidget('Viewed', 10, '#F8850B'),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: hexStringToColor('#3E3E55')),
      child: Constants.customTextWidget('Sent', 10, '#B1B1B1'),
    );
  }
}
