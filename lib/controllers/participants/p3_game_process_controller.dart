import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  double _left = 70; // 产品图片距离左右的间距
  double _height = 0;
  double _width = 0;
  double _top = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () async {
      await SystemUtil.lockScreenHorizontalDirection();
      emulateSpace(context);
    });
  }

  emulateSpace(BuildContext context) {
    // 先让高度为屏幕高度。然后按照图片比例计算宽度
    double _tempHeight = Constants.screenHeight(context);
    double _tempWidth = _tempHeight * k270ProductImageScale;
    if (_tempWidth > Constants.screenWidth(context) - 40) {
      //  如果宽度大于了最大的宽度，则重新计算高度,根据宽度计算高度
      _tempWidth = Constants.screenWidth(context) - 40;
      _tempHeight =
          (Constants.screenWidth(context) - 40) / k270ProductImageScale;
    }
    _height = _tempHeight;
    _top = (Constants.screenHeight(context) - _tempHeight) / 2.0;
    _left = (Constants.screenWidth(context) - _tempWidth) / 2.0;
    _width = _tempWidth;
    setState(() {
      print('_height=${_height}');
      print('_top=${_top}');
      print('_left=${_left}');
      print('_width=${_width}');
      print('_width1=${Constants.screenWidth(context)}');

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
                  child: Image(
                    image: AssetImage('images/product/270.png'),
                    fit: BoxFit.contain,
                    height: _height,
                  ),
                )),
            Positioned(
                left: 24,
                top: 16,
                child:GestureDetector(child: Container(
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
                ),onTap: (){
                  NavigatorUtil.pop();
                },behavior: HitTestBehavior.opaque,)),
            Positioned(
                right: 24,
                top: 16,
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
                )),
            recordWidget(context),
            Positioned(
                left: _left + _width * 0.245,
                right: _left + _width * 0.245,
                bottom: _top + 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: _width*0.49 * 0.56,
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
                      width: _width*0.49 * 0.32,
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
  }
}

Widget recordWidget(BuildContext context) {
  // 用户选择了视频录制 则显示Record图标
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  return gameUtil.selectRecord
      ? Positioned(
          left: (Constants.screenWidth(context) - 112) / 2.0,
          bottom: 4,
          child: Container(
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
          ))
      : Container();
}
