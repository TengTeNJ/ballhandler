import 'dart:async';
import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/controllers/participants/ready_controller.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/figure8_game_util.dart';
import 'package:code/utils/game_util.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/p1_game_util_new.dart';
import 'package:code/utils/p3_game_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/base/battery_view.dart';
import 'package:code/views/base/ble_view.dart';
import 'package:code/views/participants/ultimate_lights_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../../models/game/game_over_model.dart';
import '../../models/game/light_ball_model.dart';
import '../../services/sqlite/data_base.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';
import '../../utils/string_util.dart';
import '../../utils/system_device.dart';

class P3GameProcesController extends StatefulWidget {
  CameraDescription camera;

  P3GameProcesController({required this.camera});

  @override
  State<P3GameProcesController> createState() => _P3GameProcesControllerState();
}

class _P3GameProcesControllerState extends State<P3GameProcesController> {
  double _left = 45; // 产品图片距离左右的间距
  double _height = 0;
  double _width = 0;
  double _top = 0;
  List<LightBallModel> datas = [];
  late CameraController _controller;
  bool _getStartFlag = false; // 是否收到了游戏开始的数据，或许会出现中途进页面的情况
  late StreamSubscription subscription;
  bool _ready = true; // 准备阶段 游戏还没正式开始
  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  更好计算图片宽高 以及实际渲染led的位置效果
    Future.delayed(Duration(milliseconds: 100), () async {
      // await SystemUtil.lockScreenHorizontalDirection();
      emulateSpace(context);
    });
    SystemUtil.wakeUpDevice(); // 保持屏幕活跃
    SystemUtil.lockScreenHorizontalDirection();
    // 初始化所有灯的位置
    setState(() {
      datas = initLighs();
    });
    if (BluetoothManager().gameData.utimateGameSatatu == 2) {
      // 如果进页面时游戏已经开始 则不进入readyj阶段
      _ready = false;
    }
    //  初始化摄像头
    _controller = CameraController(
      widget.camera, // 选择第一个摄像头
      ResolutionPreset.medium, // 设置拍摄质量
    );
    // 获取全局变量
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.nowISGamePage = true; // 在游戏页面
    // 监听数据状态
    BluetoothManager().dataChange = (BLEDataType type) async {
      if (type == BLEDataType.statuSynchronize ||
          type == BLEDataType.allBoardStatuOneByOne) {
        // 状态同步
        // 首先取出来 刷新的是哪个灯板
        int target = BluetoothManager().gameData.currentTarget;
        // 取出来映射关系
        Map<int, int>? _map = kBoardMap[target];
        if (_map != null) {
          _map!.forEach((int key, int value) {
            if (value >= datas.length) {
              print('数据解析错误，数据超过灯的上限数量');
              return;
            }
            LightBallModel model = datas[value];
            BleULTimateLighStatu statu =
                BluetoothManager().gameData.lightStatus[key];
            if (statu == BleULTimateLighStatu.close) {
              model.show = false;
            } else {
              model.show = true;
              if (statu == BleULTimateLighStatu.red) {
                model.color = Constants.baseLightRedColor;
              } else if (statu == BleULTimateLighStatu.blue) {
                model.color = Constants.baseLightBlueColor;
              } else if (statu == BleULTimateLighStatu.redAndBlue) {
                model.color = Colors.orange;
              }
            }
          });
        }
        print('1111111111111111');
        if (type == BLEDataType.statuSynchronize) {
          // 触发更新 刷新页面
          print('2222222222222');
          setState(() {});
        }
      } else if (type == BLEDataType.allBoadrStatuFinish) {
        print('3333333333333333333');
        setState(() {});
      } else if (type == BLEDataType.refreshSingleLedStatu) {
        // 首先取出来 刷新的是哪个灯板
        print('444444444444444');
        int target = BluetoothManager().gameData.currentTarget;
        int singleLedIndex = BluetoothManager().gameData.singleLedIndex;
        BleULTimateLighStatu statu = BluetoothManager().gameData.singleLedStatu;
        // 取出来映射关系
        Map<int, int>? _map = kBoardMap[target];
        int? index = _map?[singleLedIndex];
        if (index != null) {
          LightBallModel model = datas[index!];
          if (statu == BleULTimateLighStatu.close) {
            model.show = false;
          } else {
            model.show = true;
            if (statu == BleULTimateLighStatu.red) {
              model.color = Constants.baseLightRedColor;
            } else if (statu == BleULTimateLighStatu.blue) {
              model.color = Constants.baseLightBlueColor;
            } else if (statu == BleULTimateLighStatu.redAndBlue) {
              model.color = Colors.orange;
            }
          }
        }
        setState(() {});
      } else if (type == BLEDataType.gameStatu) {
        if (BluetoothManager().gameData.utimateGameSatatu == 1) {
          // 游戏预备 一般是从保存页面返回到 p1 p2模式 设备发送准备阶段指令给app 这列进行页面刷新 p3模式目前不会主动发送进入到准备阶段
          _ready = true;
          // 延时50ms是因为_ready = true时ready页面出来了 但是可能还完成mount 那么kGameReady的监可能不会被收到
          Future.delayed(Duration(milliseconds: 50), () {
            EventBus().sendEvent(kGameReady);
          });
        } else if (BluetoothManager().gameData.utimateGameSatatu == 2) {
          // 游戏开始
          startTime = DateTime.now(); // 记录时间点
          _ready = false;
          _getStartFlag = true;
          // 数据初始化
          BluetoothManager().gameData.remainTime = 45;
          BluetoothManager().gameData.score = 0;
          setState(() {});
          // 用户选择了视频录制 则同步开始录制
          if (gameUtil.selectRecord || gameUtil.isFromAirBattle) {
            await _controller.initialize(); // 初始化摄像头控制器
            // 开始录制视频
            await _controller.startVideoRecording();
          }
        } else if (BluetoothManager().gameData.utimateGameSatatu == 3) {
          // 游戏结束
          //  _ready = true;
          endTime = DateTime.now(); // 记录时间点
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
          String gameDuration = getGameDutation();
          GameOverModel model = GameOverModel();
          model.score = (BluetoothManager().gameData.score).toString();
          model.videoPath = (gameUtil.selectRecord || gameUtil.isFromAirBattle)
              ? videoFile.path
              : '';
          model.endTime = StringUtil.dateToGameTimeString();
          int timeBetween = StringUtil.differenceInSeconds(startTime, endTime);
          model.time = timeBetween.toString();
          if (BluetoothManager().gameData.score == 0) {
            model.avgPace = '0.0';
          } else {
            model.avgPace =
                (int.parse(gameDuration) / BluetoothManager().gameData.score)
                    .toStringAsFixed(2);
            if (gameUtil.gameScene == GameScene.erqiling &&
                gameUtil.modelId == 3) {
              model.avgPace = (timeBetween / BluetoothManager().gameData.score)
                  .toStringAsFixed(2);
            }
          }
          // 释放摄像头控制器
          // await _controller.dispose();
          if (gameUtil.isFromAirBattle) {
            // 从活动来的话 积分为活动积分 不是默认的1
            model.Integral = gameUtil.activityModel.rewardPoint;
          }
          startTime = null;
          endTime = null;
          //
          if (gameUtil.gameScene == GameScene.erqiling) {
            NavigatorUtil.popAndThenPush('gameFinish', arguments: model);
          } else {
            NavigatorUtil.push('gameFinish', arguments: model);
          }
          // 标记离开游戏页面
          gameUtil.nowISGamePage = false;
          _getStartFlag = false;
        }
      } else if(type == BLEDataType.masterStatu){
        // 主机状态
        if(BluetoothManager().gameData.masterStatu != 2){
          TTToast.showErrorInfo('The device is not ready yet, please check the device',duration: 5000);
          backHandle();
        }
      }else if(type == BLEDataType.onLine){
 // 在线状态
        List<int> offLineArray = BluetoothManager().gameData.offlineBoards;
        if(!offLineArray.isEmpty){
          TTToast.showErrorInfo('A device is offline, please check the device',duration: 5000);
          backHandle();
        }
      }   else {
        setState(() {});
      }
    };
    // 进来页面发个上线 拿到0x68数据进行渲染页面
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, appOnLine());
    // 从游戏数据保存页面返回监听
    subscription = EventBus().stream.listen((event) {
      if (BluetoothManager().gameData.utimateGameSatatu == 2) {
        // 如果从保存页面返回时游戏已经开始 则不进入readyj阶段
        _ready = false;
      }
      if (event == kBackFromFinish || event == kFinishGame) {
        SystemUtil.lockScreenHorizontalDirection(); // 锁定屏幕方向
        // 隐藏状态栏
        StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
        // 从游戏完成页面返回
        print('从游戏完成页面返回');
        gameUtil.nowISGamePage = true;
        BluetoothManager().gameData.remainTime = 60;
        BluetoothManager().gameData.millSecond = 0;
        BluetoothManager().gameData.score = 0;
        if (mounted) {
          setState(() {});
        }
        if (gameUtil.modelId != 3) {
          //  NavigatorUtil.push(Routes.gameready);
        }
      }
    });
    // 如果是P3模式 则需要app进行控制
    if (gameUtil.modelId == 3) {
      // P3模式 进入到ready页面 发送游戏进入到准备阶段 让ready界面进行3 2 1倒计时
      Future.delayed(Duration(milliseconds: 500), () {
        EventBus().sendEvent(kGameReady);
      });
      // 正式进入到p3控制 p3控制时会发送游戏开始命令 上面可以监听到 则进行展示游戏页面 刷新led状态
      Future.delayed(Duration(seconds: 4), () {
        p3Control();
      });
    }
  }

/*P3模式*/
  p3Control() async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    List<int> indexs = gameUtil.selectdP3Indexs;
    // 开始游戏指令
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, gameStart());
    for (int i = 0; i < indexs.length; i++) {
      int index = indexs[i];
      if ([6].contains(index)) {
        // wide side   toe-drag   figure8模式流程和P1保持一致
        await Figure8GameUtil().startGame();
      } else {
        await P3GameManager().startGame(currentInGameIndex: index);
      }
    }
    print('P3模式结束组合');
    // 结束游戏指令
    Figure8GameUtil().stopGame();
    P3GameManager().stopGame();
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, gameStart(onStart: false));
    Future.delayed(Duration(milliseconds: 500), () {
      BluetoothManager()
          .writerDataToDevice(gameUtil.selectedDeviceModel, p3ScreenShow());
    });
  }

/*计算270图片宽高*/
  emulateSpace(BuildContext context) {
    // 先让高度为屏幕高度。然后按照图片比例计算宽度
    double _tempHeight = Constants.screenHeight(context);
    double _tempWidth = _tempHeight * k270ProductImageScale;
    if (_tempWidth > Constants.screenWidth(context) - 90) {
      //  如果宽度大于了最大的宽度，则重新计算高度,根据宽度计算高度
      _tempWidth = Constants.screenWidth(context) - 90;
      _tempHeight =
          (Constants.screenWidth(context) - 90) / k270ProductImageScale;
    }
    setState(() {
      _height = _tempHeight;
      _top = (Constants.screenHeight(context) - _tempHeight) / 2.0;
      _left = (Constants.screenWidth(context) - _tempWidth) / 2.0;
      _width = _tempWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return _ready
        ? ReadyController()
        : Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/product/270_bg.png'), // 设置背景图片
                  fit: BoxFit.cover, // 设置填充方式
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                      left: _left,
                      top: _top,
                      child: Container(
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage('images/product/270.png'),
                              fit: BoxFit.fill,
                              height: _height,
                            ),
                            Positioned(
                              child: UltimateLightsView(
                                datas: datas,
                                width: _width,
                                height: _height,
                              ),
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                            )
                          ],
                        ),
                      )),
                  Positioned(
                      left: 24,
                      top: 16,
                      child: GestureDetector(
                        child: Container(
                          child: Center(
                            child: Image(
                              image: AssetImage(
                                  'images/participants/game_back.png'),
                              width: 24,
                              height: 21,
                            ),
                          ),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                              color: hexStringToColor('#204DD1'),
                              borderRadius: BorderRadius.circular(22)),
                        ),
                        onTap: () {
                          Figure8GameUtil().stopGame();
                          P3GameManager().stopGame();
                          backHandle();
                        },
                        behavior: HitTestBehavior.opaque,
                      )),
                  Positioned(
                      right: 24,
                      top: 16,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          TTDialog.horizontalMirrorScreenDialog(context);
                        },
                        child: Container(
                          child: Center(
                            child: Image(
                              image: AssetImage('images/participants/cast.png'),
                              width: 26,
                              height: 20,
                            ),
                          ),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                              color: hexStringToColor('#204DD1'),
                              borderRadius: BorderRadius.circular(22)),
                        ),
                      )),
                  Positioned(
                    left: _left + _width * 0.245,
                    right: _left + _width * 0.245,
                    bottom:
                        ((Constants.screenHeight(context) - _height).abs()) /
                                2.0 +
                            6,
                    // top: Constants.screenHeight(context) - 45,
                    child: Container(
                      // color: Colors.red,
                      margin: EdgeInsets.only(left: 12, right: 12
                          // left: ((Constants.screenWidth(context) -
                          //             (_left + _width * 0.245) * 2) -
                          //         _width * 0.49 * 0.88 -
                          //         8) /
                          //     2.0,
                          // right: ((Constants.screenWidth(context) -
                          //             (_left + _width * 0.245) * 2) -
                          //         _width * 0.49 * 0.88 -
                          //         8) /
                          //     2.0,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              BatteryView(),
                              SizedBox(
                                width: 12,
                              ),
                              BLEView()
                            ],
                          ),
                          recordWidget(context),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: _left + _width * 0.245,
                      right: _left + _width * 0.245,
                      bottom: 53,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _width * 0.49 * 0.56,
                            height: 117,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Constants.mediumWhiteTextWidget(
                                    'TIME LEFT', 13),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Constants.digiRegularWhiteTextWidget(
                                        '00:', 72,
                                        height: 1.0),
                                    Constants.digiRegularWhiteTextWidget(
                                        BluetoothManager()
                                            .gameData
                                            .remainTime
                                            .toString()
                                            .padLeft(2, '0'),
                                        72,
                                        height: 1.0),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: _width * 0.49 * 0.32,
                            height: 117,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Constants.mediumWhiteTextWidget('SCORE', 13,
                                    height: 1.0),
                                Constants.digiRegularWhiteTextWidget(
                                    BluetoothManager()
                                        .gameData
                                        .score
                                        .toString(),
                                    72,
                                    height: 1.0)
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
  }

  // 返回操作
  backHandle(){
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (gameUtil.modelId == 3) {
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel,
          closeAllBoardLight());
      Future.delayed(Duration(milliseconds: 100),(){
        BluetoothManager().writerDataToDevice(
            gameUtil.selectedDeviceModel, p3ScreenShow());
      });
      Future.delayed(Duration(milliseconds: 150),(){
        BluetoothManager().writerDataToDevice(
            gameUtil.selectedDeviceModel, scoreShow(0));
      });
    }else{
      if (BluetoothManager().gameData.utimateGameSatatu == 2) {
        Future.delayed(Duration(milliseconds: 100),(){
          BluetoothManager().writerDataToDevice(
              gameUtil.selectedDeviceModel, selectMode(gameUtil.modelId - 1));
        });
      }
    }
    BluetoothManager().gameData.utimateGameSatatu = 0;
    NavigatorUtil.pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 解除隐藏状态栏
    StatusBarControl.setHidden(false, animation: StatusBarAnimation.SLIDE);
    SystemUtil.lockScreenDirection(); // 锁定屏幕方向
    SystemUtil.disableWakeUpDevice();
    BluetoothManager().dataChange = null;
    BluetoothManager().gameData.remainTime = 60;
    BluetoothManager().gameData.millSecond = 0;
    BluetoothManager().gameData.score = 0;
    subscription.cancel();
    if (gameUtil.gameScene == GameScene.erqiling && gameUtil.modelId == 3) {
      // 270自由模式 停止正在进行的游戏
      P1NewGameManager().stopGame();
      P3GameManager().stopGame();
      BluetoothManager()
          .writerDataToDevice(gameUtil.selectedDeviceModel, p3ScreenShow());
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, closeAllBoardLight());
    } else {

    }
  }
}

Widget recordWidget(BuildContext context) {
  // 用户选择了视频录制 则显示Record图标
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  return gameUtil.selectRecord
      ? Container(
          width: 112,
          height: 26,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: hexStringToOpacityColor('#1C1E21', 0.6)),
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
