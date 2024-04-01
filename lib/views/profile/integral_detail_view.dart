import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';
class IntegralView extends StatefulWidget {
  const IntegralView({super.key});

  @override
  State<IntegralView> createState() => _IntegralViewState();
}

class _IntegralViewState extends State<IntegralView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 16,right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Constants.mediumWhiteTextWidget('Air Battle  ', 14),
              SizedBox(height: 8,),
              Row(
                children: [
                  Constants.regularGreyTextWidget('ZIGZAG Challenge', 14),
                  SizedBox(width: 8,),
                  Constants.regularGreyTextWidget('July 2024 10:00', 14),
                ],
              )
            ],
          ),
          Constants.customTextWidget('+100', 14, '#5BCC6A')
        ],
      ),
    );
  }
}
