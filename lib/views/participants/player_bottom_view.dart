import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/top_bottom_text_view.dart';
import 'package:flutter/material.dart';

class PlayerBottomView extends StatelessWidget {
  GameOverModel model;

  PlayerBottomView({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      height: 120,
      decoration: BoxDecoration(
          color: hexStringToOpacityColor('#3E3E55', 0.85),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 42, bottom: 14, right: 42),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TBTextView(
                  title: model.rank,
                  detailTitle: 'Rank',
                  titleColor: Colors.white,
                  detailColor: Constants.baseStyleColor,
                  titleFontSize: 40,
                  detailFontSize: 14,
                ),
                TBTextView(
                  title: model.score,
                  detailTitle: 'Score',
                  titleColor: Colors.white,
                  detailColor: Constants.baseStyleColor,
                  titleFontSize: 40,
                  detailFontSize: 14,
                ),
                TBTextView(
                  title: model.avgPace,
                  detailTitle: 'Avg.pace',
                  titleColor: Colors.white,
                  detailColor: Constants.baseStyleColor,
                  titleFontSize: 40,
                  detailFontSize: 14,
                ),
              ],
            ),
          ),
          Container(
            color: hexStringToColor('#B1B1B1'),
            height: 0.5,
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage('images/airbattle/airbattle_little.png'),
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 6,),
                      Constants.regularGreyTextWidget('How many in 45', 14),
                    ],
                  ),
                  Constants.regularGreyTextWidget('JULY 1 , 2024', 10),

                ],
              ))
        ],
      ),
    );
  }
}
