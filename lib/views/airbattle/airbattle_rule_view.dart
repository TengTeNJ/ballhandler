import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';
class AirBattleRuleView extends StatelessWidget {
  String title;
  AirBattleRuleView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Constants.regularGreyTextWidget('*', 16,textAlign: TextAlign.start,height: 1.5),
          SizedBox(width: 4,),
          Expanded(child: Constants.regularGreyTextWidget(title, 16,textAlign: TextAlign.start,height: 1.5)),
        ],
      ),
    );
  }
}
