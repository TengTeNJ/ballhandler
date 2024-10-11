import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeOnePageView extends StatelessWidget {
  const SubscribeOnePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          width: 86,
          height: 42,
          image: AssetImage('images/account/potent_icon.png'),
          // fit: BoxFit.fill,
        ),
        SizedBox(
          height: 28,
        ),
        Constants.mediumWhiteTextWidget('Welcome to Potent Hockey', 16),
        SizedBox(
          height: 8,
        ),
        Constants.boldWhiteTextWidget('DangleElite', 30, height: 1.3),
        SizedBox(
          height: Constants.screenHeight(context) * 0.26,
        ),
        Padding(
          padding: EdgeInsets.only(left: 44, right: 44),
          child: Constants.mediumWhiteTextWidget(
              'Elevate your training and dominate the game Let’s take your skills to the next level!',
              14,
              height: 1.3),
        )
      ],
    );
  }
}
