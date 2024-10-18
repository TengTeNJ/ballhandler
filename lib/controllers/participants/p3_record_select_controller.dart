import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:code/models/airbattle/270_record_view.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/system_device.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../constants/constants.dart';
import '../../utils/ble_ultimate_data.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../utils/toast.dart';
import '../../views/participants/record_select_view.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class P3RecordSelectController extends StatefulWidget {
  CameraDescription camera;

  P3RecordSelectController({required this.camera});

  @override
  State<P3RecordSelectController> createState() =>
      _P3RecordSelectControllerState();
}

class _P3RecordSelectControllerState extends State<P3RecordSelectController> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _recordSelect = false;
  bool _isPortrait = true;
  bool _lockPortrait = false; // 锁定横屏是否打开
  bool isIpad = false;
  Timer? timer;
  CameraDescription? cameraDescription;
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceOrientationListen();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  /*设备方向监听*/
  deviceOrientationListen() async {
    if (Platform.isAndroid) {
      await SystemUtil.lockScreenHorizontalDirection();
    }else{
      await SystemUtil.resetScreenDirection();
    }
    Stream<NativeDeviceOrientation> stream =
        NativeDeviceOrientationCommunicator().onOrientationChanged(
      useSensor: true,
    );
    subscription = stream.listen((value) {
      if (Platform.isAndroid) {
        return;
      }
      timer?.cancel();
      timer = Timer(Duration(milliseconds: 1000), () async{
        print('NativeDeviceOrientationCommunicator() = ${await NativeDeviceOrientationCommunicator().orientation(useSensor: true)}');
        print('value = ${value}  height = ${Constants.screenHeight(context)} width = ${Constants.screenWidth(context)}');
        if (value == NativeDeviceOrientation.landscapeLeft ||
            value == NativeDeviceOrientation.landscapeRight) {
          // 横屏
          _isPortrait = false;
          if (Constants.screenWidth(context) <
              Constants.screenHeight(context)) {
            _lockPortrait = true;
          } else {
            _lockPortrait = false;
          }
        } else {
          // 竖屏
          _isPortrait = true;
        }
        if (mounted) {
          setState(() {});
        }
      });
    });
    judleIsIpad();
  }
  // 确认是否是ipad
  judleIsIpad() async{
    isIpad = await SystemUtil.isIPad();
    List<CameraDescription> cameras = await availableCameras();
    cameraDescription = cameras[cameras.length > 1 ? 1 : 0];
  }

  @override
  Widget build(BuildContext context) {
    if((Platform.isAndroid) ){
      return HorizontalScreenWidget(context);
    }else{
      return OrientationBuilder(
        builder: (context, orientation) {
          return _isPortrait
              ? HorizontalScreenWhenLockPortraitWidget(context)
              : (_lockPortrait
              ? HorizontalScreenWhenLockPortraitWidget(context)
              : HorizontalScreenWidget(context));
        },
      );
    }
  }

  //  屏幕竖直方向
  Widget VerticalScreenWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#292936'),
      body: WillPopScope(
          child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: SizedBox(
                              width: Constants.screenWidth(context),
                              height: Constants.screenHeight(context),
                              child: CameraPreview(
                                _controller,
                              )),
                        ),
                        Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                                width: Constants.screenWidth(context) * 0.175,
                                height: Constants.screenHeight(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        SystemUtil.lockScreenDirection();
                                        NavigatorUtil.pop();
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 58,
                                        decoration: BoxDecoration(
                                            color: hexStringToColor('#65657D'),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child:
                                              Constants.regularWhiteTextWidget(
                                                  'Back', 14),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      height: 58,
                                      width: 77,
                                      decoration: BoxDecoration(
                                          color: _recordSelect
                                              ? hexStringToColor('#204DD1')
                                              : hexStringToColor(
                                                  '#65657D',
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: ErQilingRecordSelectView(
                                        onTap: (value) {
                                          setState(() {
                                            _recordSelect = value;
                                            GameUtil gameUtil =
                                                GetIt.instance<GameUtil>();
                                            gameUtil.selectRecord = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ))),
                        Positioned(
                          top: (Constants.screenHeight(context) - 300) / 2.0,
                          left: (Constants.screenWidth(context) -
                                  300 / _controller.value.aspectRatio) /
                              2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: 300 / _controller.value.aspectRatio,
                              height: 300,
                              child: SizedBox(
                                  width: 300 / _controller.value.aspectRatio,
                                  height: 300,
                                  child: CameraPreview(
                                    _controller,
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          top: (Constants.screenHeight(context) - 90) / 2.0,
                          right: (Constants.screenWidth(context) * 0.175 - 90) /
                              2.0,
                          child: GestureDetector(
                            onTap: () async {
                              // 确认网络构建完成 才可以进行游戏
                              if (BluetoothManager().gameData.masterStatu !=
                                  2) {
                                TTToast.showErrorInfo(
                                    'The device is not ready yet, please check the device');
                                GameUtil gameUtil = GetIt.instance<GameUtil>();
                                // 查询主机状态
                                BluetoothManager().writerDataToDevice(
                                    gameUtil.selectedDeviceModel,
                                    queryMasterSystemStatu());
                                return;
                              }
                             // await SystemUtil.lockScreenHorizontalDirection();
                              _controller.dispose();
                              if(isIpad){
                                NavigatorUtil.popAndThenPush(
                                  Routes.ipadprocess270,
                                  arguments: cameraDescription!,
                                );
                              }else{
                                NavigatorUtil.popAndThenPush(
                                  Routes.process270,
                                  arguments: cameraDescription!,
                                );
                              }
                            },
                            child: Container(
                              width: 90,
                              height: 90,
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
                                child:
                                    Constants.boldBlackTextWidget('START', 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                ;
              }),
          onWillPop: () async {
            SystemUtil.lockScreenDirection();
            return true;
          }),
    );
  }

  // 屏幕水平方向
  Widget HorizontalScreenWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#292936'),
      body: WillPopScope(
          child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: SizedBox(
                              width: Constants.screenWidth(context),
                              height: Constants.screenHeight(context),
                              child: CameraPreview(
                                _controller,
                              )),
                        ),
                        Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                                width: Constants.screenWidth(context) * 0.175,
                                height: Constants.screenHeight(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        SystemUtil.lockScreenDirection();
                                        NavigatorUtil.pop();
                                      },
                                      child: Container(
                                        width: 77,
                                        height: 58,
                                        decoration: BoxDecoration(
                                            color: hexStringToColor('#65657D'),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child:
                                              Constants.regularWhiteTextWidget(
                                                  'Back', 14),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      height: 58,
                                      width: 77,
                                      decoration: BoxDecoration(
                                          color: _recordSelect
                                              ? hexStringToColor('#204DD1')
                                              : hexStringToColor(
                                                  '#65657D',
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: ErQilingRecordSelectView(
                                        onTap: (value) {
                                          setState(() {
                                            _recordSelect = value;
                                            GameUtil gameUtil =
                                                GetIt.instance<GameUtil>();
                                            gameUtil.selectRecord = value;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ))),
                        Positioned(
                          top: Constants.screenHeight(context) * 0.14,
                          left: Constants.screenWidth(context) * 0.175,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: Constants.screenWidth(context) * 0.65,
                              height: Constants.screenHeight(context) * 0.72,
                              child: SizedBox(
                                  width: Constants.screenWidth(context) * 0.65,
                                  height:
                                      Constants.screenHeight(context) * 0.72,
                                  child: CameraPreview(
                                    _controller,
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          top: (Constants.screenHeight(context) - 90) / 2.0,
                          right: (Constants.screenWidth(context) * 0.175 - 90) /
                              2.0,
                          child: GestureDetector(
                            onTap: () async {
                              // 确认网络构建完成 才可以进行游戏
                              if (BluetoothManager().gameData.masterStatu !=
                                  2) {
                                TTToast.showErrorInfo(
                                    'The device is not ready yet, please check the device');
                                GameUtil gameUtil = GetIt.instance<GameUtil>();
                                // 查询主机状态
                                BluetoothManager().writerDataToDevice(
                                    gameUtil.selectedDeviceModel,
                                    queryMasterSystemStatu());
                                return;
                              }
                              _controller.dispose();
                             // await SystemUtil.lockScreenHorizontalDirection();
                              if(isIpad){
                                NavigatorUtil.popAndThenPush(
                                  Routes.ipadprocess270,
                                  arguments: cameraDescription!,
                                );
                              }else{
                                NavigatorUtil.popAndThenPush(
                                  Routes.process270,
                                  arguments: cameraDescription!,
                                );
                              }
                            },
                            child: Container(
                              width: 90,
                              height: 90,
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
                                child:
                                    Constants.boldBlackTextWidget('START', 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                ;
              }),
          onWillPop: () async {
            SystemUtil.lockScreenDirection();
            print('监测到安卓按钮的返回');
            return true;
          }),
    );
  }

  // 屏幕水平方向 锁定了竖屏但是
  Widget HorizontalScreenWhenLockPortraitWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#292936'),
      body: WillPopScope(
          child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.4,
                          child: SizedBox(
                              width: Constants.screenWidth(context),
                              height: Constants.screenHeight(context),
                              child: CameraPreview(
                                _controller,
                              )),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 50,
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform(
                                  child: Container(
                                    height: 58,
                                    width: 77,
                                    decoration: BoxDecoration(
                                        color: _recordSelect
                                            ? hexStringToColor('#204DD1')
                                            : hexStringToColor(
                                                '#65657D',
                                              ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ErQilingRecordSelectView(
                                      onTap: (value) {
                                        setState(() {
                                          _recordSelect = value;
                                          GameUtil gameUtil =
                                              GetIt.instance<GameUtil>();
                                          gameUtil.selectRecord = value;
                                        });
                                      },
                                    ),
                                  ),
                                  transform: Matrix4.rotationZ(0.5 * 3.1416),
                                  // 0.5 * 2pi 弧度
                                  alignment: Alignment.center,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SystemUtil.lockScreenDirection();
                                    NavigatorUtil.pop();
                                  },
                                  child: Transform(
                                    transform: Matrix4.rotationZ(
                                        0.5 * 3.1416), // 0.5 * 2pi 弧度
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 77,
                                      height: 58,
                                      decoration: BoxDecoration(
                                          color: hexStringToColor('#65657D'),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Constants.regularWhiteTextWidget(
                                            'Back', 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                        Positioned(
                          top: 150,
                          left: 54,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              width: Constants.screenWidth(context) - 108,
                              height: Constants.screenHeight(context) - 300,
                              child: SizedBox(
                                  width: Constants.screenWidth(context) - 108,
                                  height: Constants.screenHeight(context) - 300,
                                  child: CameraPreview(
                                    _controller,
                                  )),
                            ),
                          ),
                        ),
                        Positioned(
                          right: (Constants.screenWidth(context) - 90) / 2.0,
                          bottom: 22,
                          child: GestureDetector(
                            onTap: () async {
                              // 确认网络构建完成 才可以进行游戏
                              if (BluetoothManager().gameData.masterStatu !=
                                  2) {
                                TTToast.showErrorInfo(
                                    'The device is not ready yet, please check the device');
                                GameUtil gameUtil = GetIt.instance<GameUtil>();
                                // 查询主机状态
                                BluetoothManager().writerDataToDevice(
                                    gameUtil.selectedDeviceModel,
                                    queryMasterSystemStatu());
                                return;
                              }
                              _controller.dispose();
                             // await SystemUtil.lockScreenHorizontalDirection();
                              if(isIpad){
                                NavigatorUtil.popAndThenPush(
                                  Routes.ipadprocess270,
                                  arguments: cameraDescription!,
                                );
                              }else{
                                NavigatorUtil.popAndThenPush(
                                  Routes.process270,
                                  arguments: cameraDescription!,
                                );
                              }
                            },
                            child: Transform(
                              transform: Matrix4.rotationZ(0.5 * 3.1416),
                              // 0.5 * 2pi 弧度
                              alignment: Alignment.center,
                              // 确保旋转中心是Widget的中心
                              child: Container(
                                width: 90,
                                height: 90,
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
                                  child: Constants.boldBlackTextWidget(
                                      'START', 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                ;
              }),
          onWillPop: () async {
            SystemUtil.lockScreenDirection();
            print('监测到安卓按钮的返回');
            return true;
          }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    subscription.cancel();
    timer?.cancel();
  }
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
