import 'dart:async';

import 'package:code/utils/demo_util.dart';
import 'package:code/views/participants/razor/razor_product_image_view.dart';
import 'package:code/views/participants/razor/razor_progress_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:status_bar_control/status_bar_control.dart';

import '../../constants/constants.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import '../../utils/system_device.dart';
import '../../views/base/battery_view.dart';
import '../../views/base/ble_view.dart';
import 'game_process_controller.dart';

class RazorGameProcessController extends StatefulWidget {
  const RazorGameProcessController({super.key});

  @override
  State<RazorGameProcessController> createState() =>
      _RazorGameProcessControllerState();
}

class _RazorGameProcessControllerState
    extends State<RazorGameProcessController> {
  late String _imagePath;
  bool _onStart = false;
  int _currentindex = 0;
  String _imageName = 'images/razor/progress/8/static/反1.png';
  DemoUtil? demo;
  int _count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 隐藏状态栏
    //StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
    SystemUtil.resetScreenDirection(); // 锁定屏幕方向
    SystemUtil.wakeUpDevice(); // 保持屏幕活跃
    test();
  }

  test() {
    // PaintingBinding.instance.imageCache.maximumSize = 50; // 设置缓存图片数量上限
    // PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 设置缓存大小上限为 50MB
    List<List<String>> _datas = demoDatas();
    demo = DemoUtil.razorDemo(
        razorPeriodAction: () {
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
        },
        razorGamection: () {
          String _first = _datas[_count][0];
          String index = _first.substring(0,1);
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
        },
        razorHandleAction: () {
          String _first = _datas[_count][0];
          String index = _first.substring(_first.length - 1,_first.length);
          String _second = _datas[_count][1];
          String imageName = 'images/razor/progress/${index}/static/${_second}.png';
          setState(() {
            _imageName = imageName;
            _currentindex ++;
            // 增加数组越界保护
            if(_currentindex >= _datas.length){
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
                          width: 28,
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
                      Constants.boldBlackTextWidget('Free Mode Training', 24),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Constants.digiRegularWhiteTextWidget(
                                          '00:', 76),
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
                                      BluetoothManager()
                                          .gameData
                                          .score
                                          .toString(),
                                      76)
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
                      RazorProgressView(
                        count: 10,
                        currentIndex: _currentindex,
                        onGoing: _onStart,
                      ),
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
}
