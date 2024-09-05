import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import '../../utils/toast.dart';

class P1Controller extends StatelessWidget {
  const P1Controller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkThemeColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 68,
                      ),
                      Constants.mediumWhiteTextWidget('P1 Training Mode', 24),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Constants.regularGreyTextWidget(
                            'Get ready to hone your  hockey skills with a seamless blend of warm-up and training drills, designed to enh -ance stickhandling and puck control within a dynamic 90-second session.',
                            14,
                            height: 1.2,
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Image(
                        image: AssetImage('images/participants/p1_1.apng.png'),
                        height: 148,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Constants.regularWhiteTextWidget(
                                    'wide-side-to-side(X 3 Sets)', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Move the puck across the front,navigating throuth two alternating red lights between the far left and right side', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 54,),
                      Image(
                        image: AssetImage('images/participants/p1_2.apng.png'),
                        height: 148,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Constants.regularWhiteTextWidget(
                                    'Toe-drag to slide(x 3 Sets )', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Navigate a path outlined by 4 red sensor lights across the 4 front pads. Apply wide to narrow side to-side, backhand & forehand toe-dragging techni  -ques to glide the puck over the lights.', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 54,),
                      Image(
                        image: AssetImage('images/participants/p1_3.apng.png'),
                        height: 148,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Constants.regularWhiteTextWidget(
                                    'Weave figure 8s (x 1 Set)', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Tackle figure-8 sequences in backhand side, front and fronthand side zones across the full 270-degree workout area, honing precision stickhandling in tightspaces. Dodge blue \'defenders\' and weave through shifting red lights to enhance agility, puck control, and strategic evasion skills', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 54,),
                      Image(
                        image: AssetImage('images/participants/p1_4.apng.png'),
                        height: 148,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Constants.regularWhiteTextWidget(
                                    'Training Phase: Dynamic Range Challenge', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Progress seamlessly to the dynamic training, with 1-2 red sensor lights activating across all 6 pads,covering a 270-degree workout area. It enhances spatial awareness and adaptability, essential for excelling in real-game scenarios.', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 150,),
                    ],
                  ),
                )),
            Positioned(
              top: 16,
              left: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('----------');
                        NavigatorUtil.pop();
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: hexStringToColor('#65657D')),
                        child: Center(
                          child: Image(
                            image:
                            AssetImage('images/participants/back_grey.png'),
                            width: 16,
                            height: 12,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 44,
                left: 24,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async{
                    TTToast.showLoading();
                   // NavigatorUtil.pop();
                    List<CameraDescription> cameras = await availableCameras();
                    NavigatorUtil.push(Routes.p3check, arguments: cameras[cameras.length >1 ? 1 : 0]);
                    TTToast.hideLoading();
                  },
                  child: Container(
                      width: Constants.screenWidth(context) - 48,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(182, 246, 29, 1.0),
                            Color.fromRGBO(219, 219, 20, 1.0)
                          ],
                        ),
                      ),
                      child: Center(
                        child: Constants.boldBlackTextWidget('Continue', 16),
                      )),
                ))
          ],
        ),
      ),
    );
  }
}
