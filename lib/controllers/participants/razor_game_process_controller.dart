import 'dart:async';

import 'package:camera/camera.dart';
import 'package:code/utils/demo_util.dart';
import 'package:code/utils/game_data_bus.dart';
import 'package:code/views/base/razor_statu_view.dart';
import 'package:code/views/participants/razor/razor_product_image_view.dart';
import 'package:code/views/participants/razor/razor_progress_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:status_bar_control/status_bar_control.dart';

import '../../constants/constants.dart';
import '../../models/game/game_over_model.dart';
import '../../services/sqlite/data_base.dart';
import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../utils/notification_bloc.dart';
import '../../utils/string_util.dart';
import '../../utils/system_device.dart';
import '../../views/base/battery_view.dart';
import '../../views/base/ble_view.dart';
import 'game_process_controller.dart';

class RazorGameProcessController extends StatefulWidget {
  CameraDescription camera;

  RazorGameProcessController({required this.camera});

  @override
  State<RazorGameProcessController> createState() =>
      _RazorGameProcessControllerState();
}

class _RazorGameProcessControllerState
    extends State<RazorGameProcessController> {
  late StreamSubscription subscription;
  late String _imagePath;
  late CameraController _controller;
  bool _onStart = false;
  int _currentindex = 0;
  String _imageName = 'images/razor/shape/1.png';
  DemoUtil? demo;
  int _count = 0;
  int _mode = 0; // 0是默认的，区分不出来 1是简单模式 2是高级模式
  int _lightRefreshCount = 0;
  int _shapeRefreshCount = 0;
  bool ready = false;

  @override

  initData(){
    setState(() {
      _imageName = 'images/razor/shape/1.png';
      _mode = 0;
      _lightRefreshCount = 0;
      _shapeRefreshCount = 0;
      _onStart = false;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // 隐藏状态栏
    //StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
      SystemUtil.resetScreenDirection(); // 锁定屏幕方向
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        ready = true;
      });
      SystemUtil.wakeUpDevice(); // 保持屏幕活跃
    //  初始化摄像头
    _controller = CameraController(
      widget.camera, // 选择第一个摄像头
      ResolutionPreset.medium, // 设置拍摄质量
    );
    subscription = EventBus().stream.listen((event) {
      if (event == kRazorShapeRefresh) {
        if (_onStart && _mode != 0) {
          _shapeRefreshCount++;
          var _count = _shapeRefreshCount;
          if(_count  > (kRazorPrimaryPaths.length - 1) ){
            // 防止越界
            _count = kRazorPrimaryPaths.length - 1;
          }
          setState(() {
            String imageName =
                'images/razor/shape/${kRazorPrimaryPaths[_count]}.png';
            _imageName = imageName;
          });
        }
      } else if (event == kRazorLightRefresh) {
        // 应该是第四个灯亮的时候判断得了多少分 不能是第三个灯亮的时候 ，因为用户还没来得及击打
        print('_onStart=${_onStart}_mode=${_mode}_lightRefreshCount=${_lightRefreshCount}BluetoothManager().gameData.score=${BluetoothManager().gameData.score}');
        if (_onStart && _mode == 0) {
          _lightRefreshCount++;
          if (_lightRefreshCount == 4) {
            if (BluetoothManager().gameData.score >= 3) {
              print('进入到高级模式');
              _mode = 2;
            } else {
              print('进入到初级模式');
              _mode = 1;
            }
          }
        }
      }
    });
    listenHandle();
  }

  listenHandle() {
    BluetoothManager().dataChange = (BLEDataType type) async {
      if (type == BLEDataType.gameStatu) {
        if (!BluetoothManager().gameData.gameStart) {
          // 游戏结束
          print('游戏结束');
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          XFile videoFile = XFile('');
          if ((gameUtil.selectRecord || gameUtil.isFromAirBattle)) {
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
          model.endTime = StringUtil.dateToGameTimeSecondString();
          // 释放摄像头控制器
          // await _controller.dispose();
          if (gameUtil.isFromAirBattle) {
            // 从活动来的话 积分为活动积分 不是默认的1
            model.Integral = gameUtil.activityModel.rewardPoint;
          }
          //
          var push = NavigatorUtil.push('gameFinish', arguments: model);
          // 标记离开游戏页面
          gameUtil.nowISGamePage = false;
          initData();
        } else {
          // 识别到游戏开始的标识
          _onStart = true;
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if (gameUtil.selectRecord || gameUtil.isFromAirBattle) {
            await _controller.initialize(); // 初始化摄像头控制器
            // 开始录制视频
            await _controller.startVideoRecording();
          }
        }
      }
    };
  }

  test() {
    // PaintingBinding.instance.imageCache.maximumSize = 50; // 设置缓存图片数量上限
    // PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 设置缓存大小上限为 50MB
    List<List<String>> _datas = demoDatas();
    demo = DemoUtil.razorDemo(razorPeriodAction: () {
      setState(() {
        _onStart = true;
        BluetoothManager().gameData.remainTime--;
        if (BluetoothManager().gameData.remainTime == 0) {
          demo?.razorStop();
          BluetoothManager().gameData.remainTime = 60;
          BluetoothManager().gameData.score = 0;
          _onStart = false;
          _currentindex = 0;
        }
      });
    }, razorGamection: () {
      String _first = _datas[_count][0];
      String index = _first.substring(0, 1);
      String imageName = 'images/razor/progress/${index}/${_first}.png';

      setState(() {
        BluetoothManager().gameData.score++;
        _imageName = imageName;
        // if(_count > 0){
        //   String _first1 = _datas[_count-1][0];
        //   String index1 = _first.substring(0,1);
        //   String imageName1 = 'images/razor/progress/${index1}/${_first1}.png';
        //   if (PaintingBinding.instance.imageCache.containsKey(imageName1)) {
        //     PaintingBinding.instance.imageCache.evict(imageName1);
        //   }
        // }
      });
    }, razorHandleAction: () {
      String _first = _datas[_count][0];
      String index = _first.substring(_first.length - 1, _first.length);
      String _second = _datas[_count][1];
      String imageName = 'images/razor/progress/${index}/static/${_second}.png';
      setState(() {
        _imageName = imageName;
        _currentindex++;
        // 增加数组越界保护
        if (_currentindex >= _datas.length) {
          demo?.razorStop();
          BluetoothManager().gameData.remainTime = 60;
          BluetoothManager().gameData.score = 0;
          _onStart = false;
          _currentindex = 0;
        }
      });
      _count++;
    });
    demo?.razorStart();
    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {
    //     BluetoothManager().gameData.remainTime--;
    //     if (BluetoothManager().gameData.remainTime == 0) {
    //       timer.cancel();
    //     }
    //   });
    // });
    // Future.delayed(Duration(milliseconds: 2000), () {
    //   _onStart = true;
    //   setState(() {
    //     BluetoothManager().gameData.score++;
    //     // 第一次镜像动图
    //     _imageName = 'images/razor/progress/12.png';
    //     Future.delayed(Duration(milliseconds: 1500), () {
    //       // 动图完成 到镜像
    //       setState(() {
    //         //BluetoothManager().gameData.score ++;
    //         _currentindex = 1;
    //         _imageName = 'images/razor/progress/11.png';
    //       });
    //       Future.delayed(Duration(milliseconds: 1500), () {
    //         // 1到2的切换
    //         setState(() {
    //           BluetoothManager().gameData.score++;
    //           _imageName = 'images/razor/progress/1to2.png';
    //         });
    //         Future.delayed(Duration(milliseconds: 1500), () {
    //           // 1到2的切换完成
    //           setState(() {
    //             // BluetoothManager().gameData.score ++;
    //             _currentindex = 2;
    //             _imageName = 'images/razor/progress/20.png';
    //           });
    //           Future.delayed(Duration(milliseconds: 1500), () {
    //             // 2的镜像切换
    //             setState(() {
    //               BluetoothManager().gameData.score++;
    //               _imageName = 'images/razor/progress/22.png';
    //             });
    //             Future.delayed(Duration(milliseconds: 1500), () {
    //               // 2镜像切换完成
    //               setState(() {
    //                 //BluetoothManager().gameData.score ++;
    //                 _currentindex = 3;
    //                 _imageName = 'images/razor/progress/21.png';
    //               });
    //             });
    //           });
    //         });
    //       });
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (!ready) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*电量 蓝牙状态*/
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 44,
                          height: 16,
                          decoration: BoxDecoration(
                              color: hexStringToOpacityColor('#1C1E21', 0.6),
                              borderRadius: BorderRadius.circular(2)),
                          child: Center(
                            child: BatteryView(),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: hexStringToOpacityColor('#1C1E21', 0.6),
                              borderRadius: BorderRadius.circular(5)),
                          child: BLEView(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Constants.boldBlackTextWidget('P1 Mode Training', 24),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
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
                                  Constants.mediumWhiteTextWidget(
                                      'TIME LEFT', 16),
                                  ListenableBuilder(
                                    // 合并多个监听源
                                    listenable: Listenable.merge([
                                      GameDataBus.instance.countdown,
                                    ]),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Constants.digiRegularWhiteTextWidget(
                                              '00:', 76),
                                          Constants.digiRegularWhiteTextWidget(
                                              GameDataBus
                                                  .instance.countdown.value
                                                  .toString()
                                                  .padLeft(2, '0'),
                                              76),
                                        ],
                                      );
                                    },
                                  ),
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
                                  ListenableBuilder(
                                      listenable: Listenable.merge([
                                        GameDataBus.instance.score,
                                      ]),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Constants
                                            .digiRegularWhiteTextWidget(
                                                GameDataBus.instance.score.value
                                                    .toString(),
                                                76);
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      ),
                      RazorProductImageView(imageName: _imageName),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      ),
                      // RazorProgressView(
                      //   count: 10,
                      //   currentIndex: _currentindex,
                      //   onGoing: _onStart,
                      // ),
                    ],
                  )),
                  /*返回按钮 投屏按钮 */
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // if(BluetoothManager().gameData.gameStart){
                            //   // 初始化机器
                            //   BluetoothManager()
                            //       .writerDataToDevice(gameUtil.selectedDeviceModel, resumeGameData());
                            //   //_confirmStopDialogFlag = true;
                            // true  TTDialog.confirmStopGameDialog(context, () {
                            //     _confirmStopDialogFlag = false;
                            //     NavigatorUtil.pop();
                            //   });
                            // }else{
                            //   NavigatorUtil.pop();
                            // }
                              NavigatorUtil.pop();
                          },
                          child: Container(
                            child: Center(
                              child: Image(
                                image: AssetImage(
                                    'images/participants/game_back.png'),
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
                            TTDialog.mirrorScreenDialog(context);
                          },
                          child: Container(
                            child: Center(
                              child: Image(
                                image:
                                    AssetImage('images/participants/cast.png'),
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    subscription.cancel();
    super.dispose();
  }
}
