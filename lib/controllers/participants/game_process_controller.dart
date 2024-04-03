import 'dart:io';
import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/ticker_util.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
class GameProcessController extends StatefulWidget {
  CameraDescription camera;

  GameProcessController({required this.camera});

  @override
  State<GameProcessController> createState() => _GameProcessControllerState();
}

class _GameProcessControllerState extends State<GameProcessController> with SingleTickerProviderStateMixin{
  late CameraController _controller;
  late TickerUtil _ticker;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ticker = TickerUtil(vsync: this, callBack: (){
     setState(() {

    });
    });
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
          // 启动倒计时效果
          _ticker.start();
          await _controller.initialize(); // 初始化摄像头控制器
          // 开始录制视频
          await _controller.startVideoRecording();
        } else {
          // 启动倒计时效果
          _ticker.stop();
          // 停止录制视频
          XFile videoFile = await _controller.stopVideoRecording();
          // 跳转到游戏完成页面
          GameOverModel model = GameOverModel(time: '45', score: '10', avgPace: '0.5', rank: '1', endTime: '2020');
          model.avgPace = (BluetoothManager().gameData.score / 45).toString();
          model.score = (BluetoothManager().gameData.score).toString();
          model.videoPath = videoFile.path;
          NavigatorUtil.popAndThenPush('gameFinish',arguments: model);
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? VerticalScreenWidget(context)
              : HorizontalScreenWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    BluetoothManager().dataChange = null;
    super.dispose();
  }
}

//  屏幕竖直方向
Widget VerticalScreenWidget(BuildContext context){
  return Column(
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
            height: Constants.screenHeight(context)*0.16,
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
                    BluetoothManager().gameData.showRemainTime, 20)
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: Constants.screenWidth(context) - 48,
            margin: EdgeInsets.only(left: 24, right: 24),
            height: Constants.screenHeight(context)*0.16,
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
              onTap: () {
                GameOverModel model = GameOverModel(time: '45', score: '10', avgPace: '0.5', rank: '1', endTime: '2020');
                NavigatorUtil.push('gameFinish', arguments: model);
              },
              child: Container(
                child: Center(
                  child: Image(
                    image:
                    AssetImage('images/participants/game_back.png'),
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
  );
}
// 屏幕水平方向
Widget HorizontalScreenWidget(BuildContext context){
  return Column(
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
            height: Constants.screenHeight(context)*0.16,
            decoration: BoxDecoration(
                color: hexStringToColor('#204DD1'),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Constants.mediumWhiteTextWidget('TIME LEFT', 12),
                Constants.digiRegularWhiteTextWidget(
                    BluetoothManager().gameData.showRemainTime, 14)
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: Constants.screenWidth(context) - 48,
            margin: EdgeInsets.only(left: 24, right: 24),
            height: Constants.screenHeight(context)*0.16,
            decoration: BoxDecoration(
                color: hexStringToColor('#204DD1'),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                Constants.mediumWhiteTextWidget('SCORE', 12),
                Constants.digiRegularWhiteTextWidget(
                    BluetoothManager().gameData.score.toString(), 14)
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
                    image:
                    AssetImage('images/participants/game_back.png'),
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
  );
}
