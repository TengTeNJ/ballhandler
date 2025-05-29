import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../models/airbattle/award_view_model.dart';

class AirBattleAwardView extends StatefulWidget {
  AwardViewModel model;

  AirBattleAwardView({super.key, required this.model});

  @override
  State<AirBattleAwardView> createState() => _AirBattleAwardViewState();
}

class _AirBattleAwardViewState extends State<AirBattleAwardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      height: 92,
      decoration: BoxDecoration(
        color: hexStringToColor('#3E3E55'),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(widget.model.imageName),
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(width: 26,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Constants.mediumWhiteTextWidget(widget.model.title, 20),
                    SizedBox(width: 6,),
                    Constants.mediumWhiteTextWidget(widget.model.des, 14),
                  ],
                ),
                SizedBox(height: 8,),
                Constants.regularGreyTextWidget(widget.model.detail, 14)
              ],
            )
          ],
        ),
      ),
    );
  }
}
