import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/participants/razor/add_and_sub_view.dart';
import 'package:flutter/material.dart';
class TimeAndIntervalView extends StatelessWidget {
  const TimeAndIntervalView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: Constants.screenWidth(context) - 32,
      height: 216,
      decoration: BoxDecoration(
        color: hexStringToColor('#292936'),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AddAndSubView(title: 'Training Time'),
          SizedBox(height: 30,),
          AddAndSubView(title: 'Light Interval'),
        ],
      ),
    );
  }
}
