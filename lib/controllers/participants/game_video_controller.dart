import 'package:code/constants/constants.dart';
import 'package:code/models/global/game_data.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/record.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

class GameVideoontroller extends StatefulWidget {
  CameraDescription camera;

  GameVideoontroller({required this.camera});

  @override
  State<GameVideoontroller> createState() => _GameVideoontrollerState();
}

class _GameVideoontrollerState extends State<GameVideoontroller> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String path;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化相机相关
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();

    BluetoothManager().dataChange = (BLEDataType type) async{
      if(type == BLEDataType.gameStatu){
        // 游戏开始
        if(BluetoothManager().gameData.gameStart == true){
          startRecord();
        }else{
          String videoPath =  await stopRecord();
          path = videoPath;
          //NavigatorUtil.push('videoPlay',arguments: path);
        }
      }else{
        setState(() {
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                width: Constants.screenWidth(context),
                height: Constants.screenHeight(context),
                child: CameraPreview(
                  _controller,
                  child: Stack(
                    children: [
                      Positioned(
                        top: Constants.statusBarHeight(context) + 24,
                        left: 24,
                        child: Container(
                          width: Constants.screenWidth(context) - 48,
                          // margin: EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Constants.boldWhiteTextWidget(
                                  'Shot Training', 24),
                              Consumer<UserModel>(
                                  builder: (context, user, child) {
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(27),
                                      child: Image.asset(
                                        'images/bottom/ranking_selected.png',
                                        width: 54,
                                        height: 54,
                                      ),
                                    ),
                                    Constants.boldWhiteTextWidget(
                                        user.userName, 16),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top:
                              Constants.statusBarHeight(context) + 24 + 35 + 70,
                          left: 24,
                          child: Container(
                            width: Constants.screenWidth(context) - 48,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Constants.mediumWhiteTextWidget(
                                              'TIME LEFT', 16),
                                          Constants.digiRegularWhiteTextWidget(
                                              BluetoothManager().gameData.showRemainTime, 50),
                                        ],
                                      ),
                                      width: 147,
                                      height: 114,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: hexStringToColor('#204DD1'),
                                      )),
                                ),
                                Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Constants.mediumWhiteTextWidget(
                                              'SCORE', 16),
                                          Constants.digiRegularWhiteTextWidget(
                                              BluetoothManager().gameData.score.toString(), 50),
                                        ],
                                      ),
                                      width: 100,
                                      height: 114,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: hexStringToColor('#204DD1'),
                                      )),
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 74,
                        left: 132,
                        right: 132,
                        child: Opacity(
                          opacity: 0.9,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(
                                      'images/participants/point.png'),
                                  width: 14,
                                  height: 14,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Constants.regularWhiteTextWidget(
                                    'Recording', 14),
                              ],
                            ),
                            // width: 112,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: hexStringToColor('#1C1E21')),
                          ),
                        ),
                      ),
                      Positioned(
                          left: 24,
                          right: 24,
                          bottom: 20,
                          child: Container(
                            width: Constants.screenWidth(context) - 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Opacity(
                                  opacity: 0.8,
                                  child: Container(
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                            'images/participants/cast.png'),
                                        width: 26,
                                        height: 20,
                                      ),
                                    ),
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                        color: hexStringToColor('#204DD1'),
                                        borderRadius:
                                            BorderRadius.circular(27)),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.8,
                                  child:GestureDetector(onTap: (){
                                    _controller.dispose();
                                    NavigatorUtil.pop();
                                  }, child:  Container(
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
                                    decoration: BoxDecoration(
                                        color: hexStringToColor('#204DD1'),
                                        borderRadius:
                                        BorderRadius.circular(27)),
                                  ),),
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
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
