import 'dart:async';
import 'dart:io';
import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_to_airplay/flutter_to_airplay.dart';
import 'package:get_it/get_it.dart';
import '../../utils/ble_data.dart';
import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';
import '../../utils/system_device.dart';
import '../../widgets/base/base_image.dart';

class GameProcessController extends StatefulWidget {
  CameraDescription camera;

  GameProcessController({required this.camera});

  @override
  State<GameProcessController> createState() => _GameProcessControllerState();
}

class _GameProcessControllerState extends State<GameProcessController>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late String _imagePath;
  bool _getStartFlag = false; // 是否收到了游戏开始的数据，或许会出现中途进页面的情况
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemUtil.resetScreenDirection(); // 锁定屏幕方向
    GameUtil gameUtil = GetIt.instance<GameUtil>();

    _imagePath =
        'images/product/scene${gameUtil.gameScene.index + 1}/model${gameUtil.modelId}/3.png';
    // 监听生命周期
    WidgetsBinding.instance.addObserver(this);
    // 标记进入到游戏页面
    gameUtil.nowISGamePage = true;
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
          _getStartFlag = true;
          // 数据初始化
          BluetoothManager().gameData.remainTime = 45;
          BluetoothManager().gameData.millSecond = 0;
          BluetoothManager().gameData.score = 0;
          setState(() {});
          // 用户选择了视频录制 则同步开始录制
          if (gameUtil.selectRecord || gameUtil.isFromAirBattle) {
            await _controller.initialize(); // 初始化摄像头控制器
            // 开始录制视频
            await _controller.startVideoRecording();
          }
        } else {
          // 游戏结束
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          XFile videoFile = XFile('');
          if ((gameUtil.selectRecord || gameUtil.isFromAirBattle) &&
              _getStartFlag) {
            // 停止录制视频
            videoFile = await _controller.stopVideoRecording();
            DatabaseHelper()
                .insertVideoData(kDataBaseTVideoableName, videoFile.path);
            print("videoFile.path=${videoFile.path}");
          }
          // 跳转到游戏完成页面
          GameOverModel model = GameOverModel();
          if (BluetoothManager().gameData.score == 0) {
            model.avgPace = '0.0';
          } else {
            model.avgPace =
                (45 / BluetoothManager().gameData.score).toStringAsFixed(2);
          }
          model.score = (BluetoothManager().gameData.score).toString();
          model.videoPath = (gameUtil.selectRecord || gameUtil.isFromAirBattle)
              ? videoFile.path
              : '';
          model.endTime = StringUtil.dateToGameTimeString();

          // 释放摄像头控制器
          // await _controller.dispose();

          if (gameUtil.isFromAirBattle) {
            // 从活动来的话 积分为活动积分 不是默认的1
            model.Integral = gameUtil.activityModel.rewardPoint;
          }
          //
          NavigatorUtil.push('gameFinish', arguments: model);
          // 标记离开游戏页面
          gameUtil.nowISGamePage = false;
          _getStartFlag = false;
        }
      } else if (type == BLEDataType.targetResponse) {
        // 哪个灯亮
        _imagePath =
            'images/product/scene${gameUtil.gameScene.index + 1}/model${gameUtil.modelId}/${BluetoothManager().gameData.currentTarget}.png';
        setState(() {});
      } else {
        setState(() {});
      }
    };

    // 从游戏数据保存页面返回监听
    subscription = EventBus().stream.listen((event) {
      if (event == kBackFromFinish || event == kFinishGame) {
        SystemUtil.resetScreenDirection(); // 锁定屏幕方向
        // 从游戏完成页面返回
        print('从游戏完成页面返回');
        gameUtil.nowISGamePage = true;
        BluetoothManager().gameData.remainTime = 45;
        BluetoothManager().gameData.millSecond = 0;
        BluetoothManager().gameData.score = 0;
        BluetoothManager().gameData.currentTarget = 3;
        _imagePath =
            'images/product/scene${gameUtil.gameScene.index + 1}/model${gameUtil.modelId}/${BluetoothManager().gameData.currentTarget}.png';
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  //  生命周期函数
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.nowISGamePage = false;
      print('App entered background');
    } else if (state == AppLifecycleState.resumed) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.nowISGamePage = true;
      print('App returned to foreground');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/participants/game_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? VerticalScreenWidget(context, _imagePath)
                : HorizontalScreenWidget(context, _imagePath);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    SystemUtil.lockScreenDirection(); // 锁定屏幕方向
    BluetoothManager().dataChange = null;
    // print('dataChange=null');
    // 标记离开游戏页面
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.nowISGamePage = false;
    WidgetsBinding.instance.removeObserver(this);
    BluetoothManager().gameData.remainTime = 45;
    BluetoothManager().gameData.millSecond = 0;
    BluetoothManager().gameData.score = 0;
    subscription.cancel();
    super.dispose();
  }
}

//  屏幕竖直方向
Widget VerticalScreenWidget(BuildContext context, String path) {
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  String _scene = (gameUtil.gameScene.index + 1).toString();
  String _modelId = gameUtil.modelId.toString();
  String _title =
      kGameSceneAndModelMap[_scene]![_modelId] ?? 'ZIGZAG Challenge';
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
          child: Column(
        children: [
          SizedBox(
            height: 85,
          ),
          Constants.boldBlackTextWidget(_title, 24),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Constants.screenWidth(context) * 0.56,
                  height: 133,
                  decoration: gameUtil.isFromAirBattle
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              hexStringToColor('#EF8914'),
                              hexStringToColor('#CF391A'),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10))
                      : BoxDecoration(
                          color: hexStringToColor('#204DD1'),
                          borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Constants.mediumWhiteTextWidget('TIME LEFT', 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Constants.digiRegularWhiteTextWidget('00:', 76),
                          Constants.digiRegularWhiteTextWidget(
                              BluetoothManager()
                                  .gameData
                                  .remainTime
                                  .toString()
                                  .padLeft(2, '0'),
                              76),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: Constants.screenWidth(context) * 0.32,
                  height: 133,
                  decoration: gameUtil.isFromAirBattle
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              hexStringToColor('#EF8914'),
                              hexStringToColor('#CF391A'),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10))
                      : BoxDecoration(
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
                          BluetoothManager().gameData.score.toString(), 76)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
              child: TTNetImage(
            width: Constants.screenWidth(context) - 32,
            height: Constants.screenHeight(context) - 400,
            url: path,
            placeHolderPath: 'images/product/product_6.png',
            fit: BoxFit.contain,
          )),
        ],
      )),
      Container(
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
              },
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
                decoration: gameUtil.isFromAirBattle
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#EF8914'),
                            hexStringToColor('#CF391A'),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(27))
                    : BoxDecoration(
                        color: hexStringToColor('#204DD1'),
                        borderRadius: BorderRadius.circular(27)),
              ),
            ),
            recordWidget(),
            GestureDetector(
              onTap: () async {
                BluetoothManager().writerDataToDevice(
                    BluetoothManager().deviceList[0], openAllBlueLightData());
              },
              child: Container(
                child: Center(
                  // child: Image(
                  //   image: AssetImage('images/participants/cast.png'),
                  //   width: 26,
                  //   height: 20,
                  // ),
                  child: Platform.isIOS
                      ? AirPlayRoutePickerView(
                          tintColor: Colors.white,
                          activeTintColor: Colors.white,
                          backgroundColor: Colors.transparent,
                        )
                      : Image(
                          image: AssetImage('images/participants/cast.png'),
                          width: 26,
                          height: 20,
                        ),
                ),
                width: 54,
                height: 54,
                decoration: gameUtil.isFromAirBattle
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#EF8914'),
                            hexStringToColor('#CF391A'),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(27))
                    : BoxDecoration(
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
Widget HorizontalScreenWidget(BuildContext context, String path) {
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  String _scene = (gameUtil.gameScene.index + 1).toString();
  String _modelId = gameUtil.modelId.toString();
  String _title =
      kGameSceneAndModelMap[_scene]![_modelId] ?? 'ZIGZAG Challenge';
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
          child: Stack(
        children: [
          Positioned(
            child: Constants.boldBlackTextWidget(_title, 24),
            top: 24,
            right: 0,
            left: 0,
          ),
          Positioned(
            child: Container(
              width: 180,
              height: 105,
              decoration: gameUtil.isFromAirBattle
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          hexStringToColor('#EF8914'),
                          hexStringToColor('#CF391A'),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10))
                  : BoxDecoration(
                      color: hexStringToColor('#204DD1'),
                      borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.mediumWhiteTextWidget('TIME LEFT', 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Constants.digiRegularWhiteTextWidget('00:', 60),
                      Constants.digiRegularWhiteTextWidget(
                          BluetoothManager()
                              .gameData
                              .remainTime
                              .toString()
                              .padLeft(2, '0'),
                          60),
                    ],
                  )
                ],
              ),
            ),
            left: 24,
            top: 24,
          ),
          Positioned(
            child: Container(
              width: 180,
              height: 105,
              decoration: gameUtil.isFromAirBattle
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          hexStringToColor('#EF8914'),
                          hexStringToColor('#CF391A'),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10))
                  : BoxDecoration(
                      color: hexStringToColor('#204DD1'),
                      borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Constants.mediumWhiteTextWidget('SCORE', 16),
                  Constants.digiRegularWhiteTextWidget(
                      BluetoothManager().gameData.score.toString(), 60)
                ],
              ),
            ),
            right: 24,
            top: 24,
          ),
          Positioned(
              top: 60,
              bottom: 0,
              left: 0,
              right: 0,
              child: TTNetImage(
                height: Constants.screenHeight(context) - 120,
                url: path,
                placeHolderPath: 'images/product/product_6.png',
                fit: BoxFit.contain,
              )),
        ],
      )),
      Container(
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                NavigatorUtil.pop();
              },
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
                decoration: gameUtil.isFromAirBattle
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#EF8914'),
                            hexStringToColor('#CF391A'),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(27))
                    : BoxDecoration(
                        color: hexStringToColor('#204DD1'),
                        borderRadius: BorderRadius.circular(27)),
              ),
            ),
            recordWidget(),
            GestureDetector(
              onTap: () async {
                //NavigatorUtil.push(Routes.setting);
                BluetoothManager().writerDataToDevice(
                    BluetoothManager().deviceList[0], openAllBlueLightData());
              },
              child: Container(
                child: Center(
                  child: Image(
                    image: AssetImage('images/participants/cast.png'),
                    width: 26,
                    height: 20,
                  ),
                ),
                width: 54,
                height: 54,
                decoration: gameUtil.isFromAirBattle
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#EF8914'),
                            hexStringToColor('#CF391A'),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(27))
                    : BoxDecoration(
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

Widget recordWidget() {
  // 用户选择了视频录制 则显示Record图标
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  return gameUtil.selectRecord
      ? Container(
          width: 112,
          height: 26,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: hexStringToColor('#1C1E21')),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('images/participants/point.png'),
                  width: 14,
                  height: 14,
                ),
                SizedBox(
                  width: 4,
                ),
                Constants.regularWhiteTextWidget('Recording', 14)
              ],
            ),
          ),
        )
      : Container();
}
