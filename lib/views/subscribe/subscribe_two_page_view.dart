import 'package:code/constants/constants.dart';
import 'package:code/views/subscribe/sub_two_sub_view.dart';
import 'package:flutter/material.dart';

const List<String> subTexts = [
  'Customizable training mode for your daily challenges and air battles',
  'Record your practices or airbattles in real-time.',
  'Store your videos to the cloud for playback anytime.',
  'Compete in monthly air battles and win prizes.',
  'View your performance stats and highlights after each session.'
];

class SubscribeTwoPageView extends StatelessWidget {
  const SubscribeTwoPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Constants.boldWhiteTextWidget('How It Works', 30),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
              left: Constants.screenWidth(context) * 0.14,
              right: Constants.screenWidth(context) * 0.14),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return SubTwoSubView(
                    imageName: 'images/launch/subscribe_2${index + 1}.png',
                    desText: subTexts[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 30,
                );
              },
              itemCount: subTexts.length),
        )),
        SizedBox(
          height: 42,
        ),
        Constants.mediumBaseTextWidget('Ready for more?', 14),
        SizedBox(
          height: 8,
        ),
        Container(
          child: Constants.mediumGreyTextWidget(
              'See how you stack up against players worldwide via Leaderboards.Earn rewards to redeem gifts through daily training and competition',
              14,
              height: 1.3),
          width: Constants.screenWidth(context) - 64,
        )
      ],
    );
  }
}
