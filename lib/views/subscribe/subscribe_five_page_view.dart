import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class SubscribeFivePageView extends StatelessWidget {
  const SubscribeFivePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Constants.screenHeight(context) * 0.05,
        ),
        Image(
          image: AssetImage('images/launch/subscribe_5_top.png'),
          height: 228,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 48,
        ),
        Constants.boldWhiteTextWidget('Improve with Insight', 24),
        SizedBox(
          height: 16,
        ),
        Container(
          width: Constants.screenWidth(context) - 108,
          child: Constants.mediumWhiteTextWidget(
              'Monitor your improvements over time.Gain insights into your training, and identify areas to focus on.',
              14,height: 1.3),
        )
      ],
    );
  }
}
