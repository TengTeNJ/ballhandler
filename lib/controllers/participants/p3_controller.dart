import 'package:camera/camera.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/participants/p3_grid_list_view.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';

class P3Controller extends StatefulWidget {
  const P3Controller({super.key});

  @override
  State<P3Controller> createState() => _P3ControllerState();
}

class _P3ControllerState extends State<P3Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkControllerColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 42,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 68,
                      ),
                      Constants.mediumWhiteTextWidget('Free Mode Training', 22),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Constants.regularGreyTextWidget(
                            'Please select 3-5 training modes and combine them into one free mode for training',
                            14,
                            height: 1.2,
                            textAlign: TextAlign.start),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      P3GridListView(),
                      SizedBox(
                        height: 150,
                      ),
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
                  onTap: () async {
                    TTToast.showLoading();
                    NavigatorUtil.pop();
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
