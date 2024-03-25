import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/record.dart';
import 'package:code/views/participants/record_select_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(
        showBack: true,
      ),
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Constants.screenWidth(context),
                    child: Constants.mediumWhiteTextWidget('Video Check', 24),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Container(
                    width: Constants.screenWidth(context) * 0.813,
                    height: Constants.screenHeight(context) * 0.53,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.42,
                          child: SizedBox(
                            width: Constants.screenWidth(context) * 0.813,
                            height: Constants.screenHeight(context) * 0.53,
                            child: CameraPreview(
                              _controller,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Constants.screenHeight(context) * 0.04,
                          left: Constants.screenWidth(context) * 0.1315,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(61),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: DashedBorder.fromBorderSide(
                                      dashLength: 5,
                                      side: BorderSide(
                                          color:
                                              Color.fromRGBO(39, 182, 245, 1.0),
                                          width: 1)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: Constants.screenWidth(context) * 0.55,
                              height: Constants.screenHeight(context) * 0.45,
                              child: SizedBox(
                                width: Constants.screenWidth(context) * 0.55,
                                height: Constants.screenHeight(context) * 0.45,
                                child: CameraPreview(
                                  _controller,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    //color: Colors.red,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: Constants.screenWidth(context),
                    child: Constants.regularWhiteTextWidget(
                        'Please place the product in the center of the video',
                        12),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                        color: hexStringToColor('#4B5F9A'),
                        borderRadius: BorderRadius.circular(10)),
                    child: RecordSelectView(),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _controller.dispose();
                      List<CameraDescription> cameras =
                      await availableCameras();
                      NavigatorUtil.popAndThenPush(
                        'gameVideo',
                        arguments: cameras[0],
                      );
                      // bool hasGranted = false;
                      // final PermissionStatus status = await Permission.storage.status;
                      // hasGranted = (status == PermissionStatus.granted);
                      // if(hasGranted == false){
                      //   final requestStatus = await Permission.storage.request();
                      //   hasGranted = (requestStatus == PermissionStatus.granted);
                      // }
                      // if(hasGranted == true){
                      //   // 这里要及时释放_controller(虽然dispose里面进行了释放)，因为可能会跳转到下个界面时的新的controller生成时，这个controller还没释放，导致相机资源不正及时分配给新的页面，会白屏
                      //   _controller.dispose();
                      //   List<CameraDescription> cameras =
                      //   await availableCameras();
                      //   NavigatorUtil.popAndThenPush(
                      //     'gameVideo',
                      //     arguments: cameras[0],
                      //   );
                      // }
                    },
                    child: Container(
                      width: Constants.screenWidth(context) * 0.813,
                      height: 56,
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
    print('dispose----');
    _controller.dispose();
    super.dispose();
  }
}
