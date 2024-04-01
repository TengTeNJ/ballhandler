import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/profile/exchange_rewards_list_view.dart';
import 'package:code/views/profile/integral_next_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:flutter/material.dart';

class IntegralController extends StatefulWidget {
  const IntegralController({super.key});

  @override
  State<IntegralController> createState() => _IntegralControllerState();
}

class _IntegralControllerState extends State<IntegralController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      body: Column(
        children: [
          Container(
            height: 36,
            margin: EdgeInsets.only(top: 24),
            child: Stack(
              children: [
                Positioned(right: 16, child: CancelButton()),
                Center(
                  child: Constants.boldWhiteTextWidget('You Progress', 20),
                )
              ],
            ),
          ),
          SizedBox(
            height: 48,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Constants.boldBaseTextWidget('300', 40),
              SizedBox(
                height: 8,
              ),
              Constants.regularGreyTextWidget('Potent Hockey Points', 14),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  print('to integral detail');
                  NavigatorUtil.push('integralDetail');
                },
                child: Container(
                  width: 60,
                  height: 23,
                  decoration: BoxDecoration(
                    color: hexStringToColor('#292936'),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Constants.regularBaseTextWidget('Detail', 12),
                        SizedBox(
                          width: 4,
                        ),
                        Image(
                          image: AssetImage('images/profile/back.png'),
                          width: 5,
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 36,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: IntegralNextView(),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            child: Constants.mediumWhiteTextWidget('Exchange Rewards', 16,
                textAlign: TextAlign.left),
            width: Constants.screenWidth(context) - 32,
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(child: ExchangeRewardListView())
        ],
      ),
    );
  }
}
