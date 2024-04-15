import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/views/participants/record_select_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class RecordSelectController extends StatefulWidget {
  const RecordSelectController({super.key});

  @override
  State<RecordSelectController> createState() => _RecordSelectControllerState();
}

class _RecordSelectControllerState extends State<RecordSelectController> {
  bool _recordSelect = false;
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: Stack(
        children: [
          Positioned(
              left: 16,
              top: 60,
              child: GestureDetector(
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
                      image: AssetImage('images/participants/back_grey.png'),
                      width: 16,
                      height: 12,
                    ),
                  ),
                ),
              )),
          Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Constants.mediumWhiteTextWidget('ZIGZAG Challenge', 24)),
          Positioned(
              left: 0,
              right: 0,
              top: 146,
              bottom: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
               Expanded(child:  Image(image: AssetImage('images/product/product_check_${gameUtil.modelId}.png'))),
                  SizedBox(height: 16,),
                  Constants.regularWhiteTextWidget('Please place the shapes according to the legend', 14),
                 SizedBox(height: 24,),
                 Container(
                   height: 36,
                   width: 112,
                   decoration: BoxDecoration(
                     color: hexStringToOpacityColor('#4B5F9A', 0.5),
                     borderRadius: BorderRadius.circular(5)
                   ),
                   child: RecordSelectView(onTap: (value){
                     _recordSelect = value;
                     GameUtil gameUtil = GetIt.instance<GameUtil>();
                      gameUtil.selectRecord = value;
                   },),
                 )
                ],
              )),
          Positioned(
            left: 24,
            bottom: 32,
            child: GestureDetector(
              onTap: () async {
                List<CameraDescription> cameras =
                await availableCameras();
                if(_recordSelect){
                  // 视频check
                  NavigatorUtil.popAndThenPush(
                    Routes.videocheck,
                    arguments: cameras[0],
                  );
                }else{
                  // 游戏页面
                  NavigatorUtil.popAndThenPush(Routes.gameprocess,arguments: cameras[0]);
                }
              },
              child: Container(
                width: Constants.screenWidth(context) * 0.813,
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
                  child: Constants.boldBlackTextWidget('START', 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
