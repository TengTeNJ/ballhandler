import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeThreePageView extends StatelessWidget {
  const SubscribeThreePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Constants.screenHeight(context) * 0.1,
        ),
        Image(
          image: AssetImage('images/launch/subscribe_3_top.png'),
          height: 143,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 92,
        ),
        Constants.boldWhiteTextWidget('Train Like a Pro', 24),
        SizedBox(
          height: 16,
        ),
        Container(
          width: Constants.screenWidth(context) - 108,
          child: Constants.mediumWhiteTextWidget(
              'Get automated stats, record your session for video highlights and replay',
              14,height: 1.3),
        )
      ],
    );
  }
}
