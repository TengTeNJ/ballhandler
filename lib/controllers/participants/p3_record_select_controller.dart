import 'package:camera/camera.dart';
import 'package:code/models/airbattle/270_record_view.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/system_device.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../constants/constants.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../views/participants/record_select_view.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 锁定屏幕为横屏
     SystemUtil.lockScreenHorizontalDirection();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexStringToColor('#292936'),
      body: WillPopScope(child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(child: Stack(
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: SizedBox(
                      width: Constants.screenWidth(context),
                      height: Constants.screenHeight(context),
                      child: CameraPreview(
                        _controller,
                      ),
                    ),
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
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Constants.regularWhiteTextWidget(
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
                                    borderRadius: BorderRadius.circular(5)),
                                child: ErQilingRecordSelectView(
                                  onTap: (value) {
                                    setState(() {
                                      _recordSelect = value;
                                      GameUtil gameUtil = GetIt.instance<GameUtil>();
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
                        decoration: BoxDecoration(
                          color: Colors.red,
                          // borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Color.fromRGBO(39, 182, 245, 1.0),
                              width: 0.5),
                        ),
                        width: Constants.screenWidth(context) * 0.65,
                        height: Constants.screenHeight(context) * 0.72,
                        child: SizedBox(
                          width: Constants.screenWidth(context) * 0.65,
                          height: Constants.screenHeight(context) * 0.72,
                          child: CameraPreview(
                            _controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (Constants.screenHeight(context) - 90) / 2.0,
                    right: (Constants.screenWidth(context) * 0.175 - 90) / 2.0,
                    child: GestureDetector(
                      onTap: () async {
                        _controller.dispose();
                        List<CameraDescription> cameras =
                        await availableCameras();
                        NavigatorUtil.popAndThenPush(
                          Routes.process270,
                          arguments: cameras[0],
                        );
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
                          child: Constants.boldBlackTextWidget('START', 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),);
            } else {
              return Center(child: CircularProgressIndicator());
            }
            ;
          }), onWillPop: ()async{
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
