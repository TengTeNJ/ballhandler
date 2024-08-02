import 'dart:async';

import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/game_util.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/base/battery_view.dart';
import 'package:code/views/base/ble_view.dart';
import 'package:code/views/participants/ultimate_lights_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/game/light_ball_model.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      // await SystemUtil.lockScreenHorizontalDirection();
      emulateSpace(context);
    });
    // 初始化所有灯的位置
    setState(() {
      datas = initLighs();
    });
    // 监听数据状态
    BluetoothManager().dataChange = (BLEDataType type) async {
      if(type == BLEDataType.statuSynchronize || type == BLEDataType.allBoardStatuOneByOne){
        // 状态同步
        // 首先取出来 刷新的是哪个灯板
        int target = BluetoothManager().gameData.currentTarget;
        // 取出来映射关系
        Map<int,int>? _map = kBoardMap[target];
        if(_map != null){
           _map!.forEach((int key,int value){
             if(value >= datas.length){
               print('数据解析错误，数据超过灯的上限数量');
               return;
             }
             LightBallModel model = datas[value];
             BleULTimateLighStatu statu = BluetoothManager().gameData.lightStatus[key];
             if(statu == BleULTimateLighStatu.close){
               model.show = false;
             }else{
               model.show = true;
               if(statu == BleULTimateLighStatu.red){
                 model.color = Constants.baseLightRedColor;
               }else if(statu == BleULTimateLighStatu.blue){
                 model.color = Constants.baseLightBlueColor;
               }else if(statu == BleULTimateLighStatu.redAndBlue){
                 model.color = Colors.orange;
               }
             }

           });
        }
        if(type == BLEDataType.statuSynchronize){
          // 触发更新是 刷新页面
          setState(() {

          });
        }

      } else{
        setState(() {

        });
      }
    };
    // 进来页面发个上线 拿到0x68数据进行渲染页面
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, appOnLine());
  }

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

    return Scaffold(
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
                        image: AssetImage('images/participants/game_back.png'),
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
                    NavigatorUtil.pop();
                  },
                  behavior: HitTestBehavior.opaque,
                )),
            Positioned(
                right: 24,
                top: 16,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    TTDialog.mirrorScreenDialog(context);
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
                  ((Constants.screenHeight(context) - _height).abs()) / 2.0 + 6,
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
                          Constants.mediumWhiteTextWidget('TIME LEFT', 13),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Constants.digiRegularWhiteTextWidget('00:', 76,
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
                              BluetoothManager().gameData.score.toString(), 72,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemUtil.lockScreenDirection();
    BluetoothManager().dataChange = null;
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
