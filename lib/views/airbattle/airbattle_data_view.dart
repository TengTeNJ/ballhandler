import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/top_bottom_text_view.dart';
import 'package:flutter/material.dart';

enum Grade {
  normal,
  silver,
  gold,
}

class AirBattleDataView extends StatelessWidget {
  Grade grade;
  bool hasVideo;
  String userName;
  String area;
  String birthday;
  String rank;
  String score;
  String avgPace;

  AirBattleDataView(
      {required this.userName,
      required this.area,
      required this.birthday,
      required this.rank,
      required this.score,
      required this.avgPace,
      this.hasVideo = false,
      this.grade = Grade.normal});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          hasVideo == true
              ? Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                      width: 32,
                      height: 14,
                      decoration: BoxDecoration(
                          color: Constants.baseStyleColor,
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(
                          child: Constants.regularWhiteTextWidget('View', 10))))
              : Container(),
          Positioned(
            left: 24,
            top: 6,
            bottom: 6,
            right: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(grade == Grade.gold
                      ? "images/airbattle/gold.png"
                      : "images/airbattle/icon.png"),
                  width: 48,
                  height: 48,
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget(userName, 14),
                          SizedBox(
                            width: 4,
                          ),
                          Constants.regularGreyTextWidget(area, 10),
                          SizedBox(
                            width: 6,
                          ),
                          Constants.regularGreyTextWidget(birthday, 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TBTextView(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              title: rank.toString(),
                              detailTitle: 'Rank'),
                          TBTextView(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              title: score.toString(),
                              detailTitle: 'Score'),
                          TBTextView(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              title: avgPace.toString(),
                              detailTitle: 'Avg.Pace'),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
