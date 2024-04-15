import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../services/http/profile.dart';

class IntegralNextView extends StatefulWidget {
  MyAccountDataModel model;
   IntegralNextView({required this.model});

  @override
  State<IntegralNextView> createState() => _IntegralNextViewState();
}

class _IntegralNextViewState extends State<IntegralNextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
          color: hexStringToColor('#292936'),
          borderRadius: BorderRadius.circular(5)),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Constants.regularGreyTextWidget(
                'Points will be cleared in January 2025', 10),
            bottom: 8
          ),
          Center(
            child: Container(
              // color: Colors.red,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/profile/progress_${widget.model.memberLevel}.png'),
                  width: 37,
                  height: 43,
                ),
                SizedBox(width: 16,),
                Container(
                  width: 226,
                  height: 43,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Constants.regularGreyTextWidget('Next Level', 14),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.model.integral.toString(),
                                  style: TextStyle(
                                      color: Constants.baseStyleColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: '/${widget.model.upperLimit.toString()}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 6,),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        value: 0.3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.baseStyleColor),
                      )
                    ],
                  ),
                ),
              ],
            ),),
          ),
        ],
      ),
    );
  }
}
