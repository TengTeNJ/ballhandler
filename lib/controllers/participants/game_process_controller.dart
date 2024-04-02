import 'dart:io';

import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class GameProcessController extends StatefulWidget {
  CameraDescription camera;

  GameProcessController({required this.camera});

  @override
  State<GameProcessController> createState() => _GameProcessControllerState();
}

class _GameProcessControllerState extends State<GameProcessController> {
  late CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //  初始化摄像头
    _controller = CameraController(
      widget.camera, // 选择第一个摄像头
      ResolutionPreset.medium, // 设置拍摄质量
    );
    // 蓝牙数据监听
    BluetoothManager().dataChange = (BLEDataType type) async {
      if (type == BLEDataType.gameStatu) {
        // 游戏开始
        if (BluetoothManager().gameData.gameStart == true) {
          await _controller.initialize(); // 初始化摄像头控制器
          // 开始录制视频
          await _controller.startVideoRecording();
        } else {
          // 停止录制视频
          XFile videoFile = await _controller.stopVideoRecording();
          // 跳转到游戏完成页面
          GameOverModel model = GameOverModel();
          model.avgPace = BluetoothManager().gameData.score / 45;
          model.score = BluetoothManager().gameData.score;
          model.videoPath = videoFile.path;
          NavigatorUtil.push('gameFinish', arguments: model);
          // 释放摄像头控制器
          await _controller.dispose();
        }
      } else {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Constants.boldWhiteTextWidget('ZIGZAG Challenge', 24),
              SizedBox(
                height: 32,
              ),
              Container(
                width: Constants.screenWidth(context) - 48,
                margin: EdgeInsets.only(left: 24, right: 24),
                height: 133,
                decoration: BoxDecoration(
                    color: hexStringToColor('#204DD1'),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Constants.mediumWhiteTextWidget('TIME LEFT', 16),
                    Constants.digiRegularWhiteTextWidget(
                        BluetoothManager().gameData.showRemainTime, 80)
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: Constants.screenWidth(context) - 48,
                margin: EdgeInsets.only(left: 24, right: 24),
                height: 133,
                decoration: BoxDecoration(
                    color: hexStringToColor('#204DD1'),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Constants.mediumWhiteTextWidget('SCORE', 16),
                    Constants.digiRegularWhiteTextWidget(
                        BluetoothManager().gameData.score.toString(), 80)
                  ],
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
            color: Colors.red,
          )),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: Image(
                      image: AssetImage('images/participants/cast.png'),
                      width: 26,
                      height: 20,
                    ),
                  ),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                      color: hexStringToColor('#204DD1'),
                      borderRadius: BorderRadius.circular(27)),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: Center(
                      child: Image(
                        image: AssetImage('images/participants/game_back.png'),
                        width: 26,
                        height: 20,
                      ),
                    ),
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                        color: hexStringToColor('#204DD1'),
                        borderRadius: BorderRadius.circular(27)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
