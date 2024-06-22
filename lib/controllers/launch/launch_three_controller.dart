import 'package:code/utils/nsuserdefault_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constants/constants.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';

class LaunchThreeController extends StatelessWidget {
  const LaunchThreeController({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      NSUserDefault.setKeyValue(kShowLaunch, "done");
    });
    return Scaffold(
        body: Container(
      color: hexStringToColor("#292936"),
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
            left: 20,
            right: 20,
            top: 88,
            child: Image(
              image: AssetImage("images/launch/launch_3.png"),
              width: 246,
              height: 221,
            ),
          ),
          Positioned(
              left: 24,
              right: 24,
              top: 345,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants.customTextWidget(
                        textAlign: TextAlign.start,
                        "Exclusive Membership Benefits:",
                        15,
                        "#FBBA00",
                        fontWeight: FontWeight.w500),
                    SizedBox(
                      height: 12,
                    ),
                    Constants.boldWhiteTextWidget(
                      textAlign: TextAlign.start,
                        "Full Privilege to Potent Hockey DanglerStar App", 20,height: 1.25),
                    SizedBox(height: 20,),
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
                              "Daily Challenges",
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
                              "Leaderboards",
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
                              "Earn Awards and Rewards",
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
                    SizedBox(height: 55,),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        print('Join Now');
                        NavigatorUtil.popToRoot();
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Constants.baseStyleColor
                        ),
                        child: Center(child: Constants.mediumWhiteTextWidget('Join Now', 16),),
                      ),
                    ),
                    SizedBox(height: 24,),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        print('Maybe later');
                        NavigatorUtil.popToRoot();
                      },
                      child: Container(
                        child: Center(child: Constants.mediumGreyTextWidget('Maybe later', 16),),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    ));
  }
}
