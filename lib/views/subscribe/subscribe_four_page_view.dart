import 'package:flutter/material.dart';

import '../../constants/constants.dart';
class SubscribeFourPageView extends StatelessWidget {
  const SubscribeFourPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Constants.screenHeight(context) * 0.05,
        ),
        Image(
          image: AssetImage('images/launch/subscribe_4_top.png'),
          height: 200,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 76,
        ),
        Constants.boldWhiteTextWidget('Be Part of a Community', 24),
        SizedBox(
          height: 16,
        ),
        Container(
          width: Constants.screenWidth(context) - 108,
          child: Constants.mediumWhiteTextWidget(
              'Track your progress and see how you rank against players worldwide',
              14,height: 1.3),
        )
      ],
    );
  }
}
