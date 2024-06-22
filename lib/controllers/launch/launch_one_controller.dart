import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

class LaunchOneController extends StatelessWidget {
  const LaunchOneController({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(child: Container(
          decoration: BoxDecoration(
              color: hexStringToColor("#292936"),
              image: DecorationImage(
                image: AssetImage(
                  'images/launch/launch_1.png',
                ),
                fit: BoxFit.fill,
              )),
          child: Stack(
            children: [
              Positioned(
                  left: 16,
                  right: 16,
                  top: Constants.screenHeight(context) * 0.56,
                  child: Constants.boldWhiteTextWidget(
                      "Welcome to Potent Hockey DangleElite Unlock Your Full Potential with Elite Membership!",
                      20,
                      height: 1.25,
                      textAlign: TextAlign.center)),
              Positioned(
                  left: 24,
                  right: 24,
                  bottom: 66,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      print('去启动介绍页2');
                      NavigatorUtil.push(Routes.launch2);
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants.baseStyleColor
                      ),
                      child: Center(child: Constants.mediumWhiteTextWidget('Next', 16),),
                    ),
                  )),
            ],
          ),
        ), onWillPop: (){
          return Future.value(false);
        }));
  }
}
