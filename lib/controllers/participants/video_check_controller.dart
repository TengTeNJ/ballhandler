import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../utils/global.dart';

class VideoCheckController extends StatefulWidget {
  CameraDescription camera;

  VideoCheckController({required this.camera});

  @override
  State<VideoCheckController> createState() => _VideoCheckControllerState();
}

class _VideoCheckControllerState extends State<VideoCheckController> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Opacity(
                    opacity: 0.42,
                    child: SizedBox(
                      width: Constants.screenWidth(context) ,
                      height: Constants.screenHeight(context) ,
                      child: CameraPreview(
                        _controller,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 60,
                    child:GestureDetector(
                      onTap: (){
                        NavigatorUtil.pop();
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: hexStringToColor('#65657D')),
                        child: Center(
                          child: Image(
                            image: AssetImage('images/participants/back_grey.png'),
                            width: 16,
                            height: 12,
                          ),
                        ),
                      ),
                    )
                  ),
                  Positioned(
                    top: Constants.screenHeight(context) * 0.2,
                    left: Constants.screenWidth(context) * 0.12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(61),
                      child: Container(
                        // decoration: BoxDecoration(
                        //     border: DashedBorder.fromBorderSide(
                        //         dashLength: 5,
                        //         side: BorderSide(
                        //             color:
                        //             Color.fromRGBO(39, 182, 245, 1.0),
                        //             width: 1)),
                        //     borderRadius:
                        //     BorderRadius.all(Radius.circular(10))),
                        width: Constants.screenWidth(context) * 0.76,
                        height: Constants.screenHeight(context) * 0.6,
                        child: SizedBox(
                          child: CameraPreview(
                            _controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 54,
                    child:  GestureDetector(
                    onTap: () async {
                      _controller.dispose();
                      List<CameraDescription> cameras =
                      await availableCameras();
                      NavigatorUtil.popAndThenPush(
                        'gameProcess',
                        arguments: cameras[0],
                      );
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: gameUtil.isFromAirBattle ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            hexStringToColor('#EF8914'),
                            hexStringToColor('#CF391A')
                          ],
                        ) : LinearGradient(
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
                  ),)
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
            ;
          }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
