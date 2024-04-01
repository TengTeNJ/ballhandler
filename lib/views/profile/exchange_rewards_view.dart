import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

class ExchangeRewardsView extends StatefulWidget {
  const ExchangeRewardsView({super.key});

  @override
  State<ExchangeRewardsView> createState() => _ExchangeRewardsViewState();
}

class _ExchangeRewardsViewState extends State<ExchangeRewardsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: hexStringToColor('#292936')),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('images/base/five.png'),
            width: 113,
            height: 113,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Constants.regularGreyTextWidget('Amazon 200\$ Coupons', 14),
              SizedBox(height: 8,),
              Constants.regularBaseTextWidget('1000 Points', 14),
            ],
          ),
        ],
      ),
    );
  }
}
