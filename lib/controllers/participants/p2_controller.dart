import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/toast.dart';

class P2Controller extends StatelessWidget {
  const P2Controller({super.key});

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
                      Constants.mediumWhiteTextWidget('P2 Dynamic Gaameplay Mode', 22),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Constants.regularGreyTextWidget(
                            'P2 Mode takes you through a 120-second evolving drill sequence within a 270-degree workout area, designed to progressively enhance stickhandling, precision, and strategic play. This mode\'s structure intensifies across three phases, expanding the workout range and increa  -sing the complexity of targets and defenders to simula  -te escalating game scenarios. ',
                            14,
                            height: 1.2,
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Image(
                        image: AssetImage('images/participants/p2_1.apng.png'),
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
                                    'Foundations Flex (45 seconds total)', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Navigate 15 seconds in each of the three two-pad zones , engaging with 1 or 2 red lights randomly up across two pads, each worth 2 points, and dodginga single blue \'defender\' light, demanding quickreactions and agile decision-making.', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 54,),
                      Image(
                        image: AssetImage('images/participants/p2_2.apng.png'),
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
                                    'Mastery Merge (45 seconds)', 14,
                                    height: 1.2, textAlign: TextAlign.start)
                              ],
                            ),
                            Constants.regularGreyTextWidget(
                                'Master the full workout area, applying a wide array of advanced techniques to outmaneuver defenders and navigate complex scenarios, mirroring the unpredictability of real-game situations. ', 14,
                                height: 1.2, textAlign: TextAlign.start)
                          ],
                        ),
                      ),
                      SizedBox(height: 54,),
                      Image(
                        image: AssetImage('images/participants/p2_3.apng.png'),
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
                    //NavigatorUtil.pop();
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
