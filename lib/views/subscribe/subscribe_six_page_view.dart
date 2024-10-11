import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeSixPageView extends StatelessWidget {
  const SubscribeSixPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Constants.screenHeight(context) * 0.1,
        ),
        Image(
          image: AssetImage('images/launch/subscribe_6_top.png'),
          height: 172,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 66,
        ),
        Constants.boldWhiteTextWidget('Earn Pucks and Rewards', 24),
        SizedBox(
          height: 16,
        ),
        Container(
          width: Constants.screenWidth(context) - 108,
          child: Constants.mediumWhiteTextWidget(
              'Earn pucks by completing challenges and battles.Redeem your pucks for exclusive gifts and prizes!',
              14,height: 1.3),
        )
      ],
    );
  }
}
