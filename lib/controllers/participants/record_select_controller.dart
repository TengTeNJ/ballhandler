import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/views/participants/record_select_view.dart';
import 'package:code/widgets/base/base_image.dart';
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
    String _scene = (gameUtil.gameScene.index+1).toString();
    String _modelId = gameUtil.modelId.toString();
    String _title = kGameSceneAndModelMap[_scene]![_modelId] ?? 'ZIGZAG Challenge';

    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 60),
                child: Row(
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
              SizedBox(
                height: 4,
              ),
              Constants.mediumWhiteTextWidget(_title, 24),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TTNetImage(
                width: Constants.screenWidth(context) - 32,
                height: Constants.screenHeight(context) - 400,
                url:
                    'https://potent-hockey.s3.eu-north-1.amazonaws.com/product/check/scene1/${gameUtil.modelId}.png',
                placeHolderPath: 'images/product/product_check_6.png',
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 32,
              ),
              Constants.regularWhiteTextWidget(
                  'Please place the shapes according to the legend', 14),
              SizedBox(
                height: 16,
              ),
              gameUtil.isFromAirBattle
                  ? Container()
                  : Container(
                      height: 36,
                      width: 112,
                      decoration: BoxDecoration(
                          color: hexStringToOpacityColor('#4B5F9A', 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: RecordSelectView(
                        onTap: (value) {
                          _recordSelect = value;
                          GameUtil gameUtil = GetIt.instance<GameUtil>();
                          gameUtil.selectRecord = value;
                        },
                      ),
                    )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 54),
            child: GestureDetector(
              onTap: () async {
                List<CameraDescription> cameras = await availableCameras();
                if (_recordSelect) {
                  // 视频check
                  NavigatorUtil.popAndThenPush(
                    Routes.videocheck,
                    arguments: cameras[0],
                  );
                } else {
                  // 游戏页面
                  NavigatorUtil.popAndThenPush(Routes.gameprocess,
                      arguments: cameras[0]);
                }
              },
              child: Container(
                  width: Constants.screenWidth(context) * 0.813,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: gameUtil.isFromAirBattle
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              hexStringToColor('#EF8914'),
                              hexStringToColor('#CF391A')
                            ],
                          )
                        : LinearGradient(
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
            ),
          )
        ],
      ),
    );
  }
}
