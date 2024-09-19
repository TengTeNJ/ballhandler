import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class LaunchTwoController extends StatelessWidget {
  const LaunchTwoController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          color: hexStringToColor("#292936"),
          image: DecorationImage(
            image: AssetImage(
              'images/launch/launch_2.png',
            ),
            fit: BoxFit.fill,
          )),
      child: Stack(
        children: [
          Positioned(
              left: 16,
              top: 64,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigatorUtil.pop();
                },
                child: Image(
                  width: 11,
                  height: 21,
                  fit: BoxFit.fill,
                  image: AssetImage('images/launch/back.png'),
                ),
              )),
          Positioned(
            left: 24,
            right: 24,
            top: Constants.screenHeight(context) * 0.5,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Constants.boldWhiteTextWidget(
                      textAlign: TextAlign.start,
                      "Full Privilege To DangleElite App",
                      20,
                      height: 1.25),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "Daily Training & Challenges",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                  SizedBox(height: 14,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "Air-Batt Challenges",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                  SizedBox(height: 14,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "Leaderboards/Ranking",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                  SizedBox(height: 14,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "Performance & Progress Tracking",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                  SizedBox(height: 14,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "Earn Awards & Redeem for Rewards",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                  SizedBox(height: 14,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('images/launch/done.png'),
                        width: 16,
                        height: 16,
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: Constants.screenWidth(context) - 72,
                        child: Constants.boldWhiteTextWidget(
                            textAlign: TextAlign.start,
                            "And More...",
                            14,
                            height: 1.2),
                      )
                    ],
                  ),
                ],
              ),
              // color: Colors.red,
            ),
          ),
          Positioned(
              left: 24,
              right: 24,
              bottom: 66,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  print('去启动介绍页2');
                  NavigatorUtil.popToRoot();
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.baseStyleColor
                  ),
                  child: Center(child: Constants.mediumWhiteTextWidget('Let\'s Start', 16),),
                ),
              )),
        ],
      ),
    ));
  }
}
