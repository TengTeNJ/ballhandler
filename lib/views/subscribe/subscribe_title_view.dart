import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class SubscribeTitleView extends StatelessWidget {
  const SubscribeTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 48,
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Constants.mediumGreyTextWidget('Basic(free)', 14),
          SizedBox(
            width: 24,
          ),
          Container(
            width: 92,
            height: 20,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hexStringToColor('#EF8914'),
                    hexStringToColor('#CF391A')
                  ],
                  begin: Alignment.topLeft, // 渐变起始点
                  end: Alignment.bottomRight, // 渐变结束点
                ),
                borderRadius: BorderRadius.circular(11)),
            child: Center(
              child: Constants.mediumWhiteTextWidget('Membership', 14),
            ),
          )
        ],
      ),
    );
  }
}
