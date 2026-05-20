import 'package:camera/camera.dart';
import 'package:code/utils/ble_razor_data.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/shape_transformer.dart';
import 'package:code/views/participants/razor_grid_view.dart';
import 'package:code/views/participants/razor_mode_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../constants/constants.dart';
import '../../route/route.dart';
import '../../utils/ble_razor_service_data.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class RazorP1Controller extends StatelessWidget {
  const RazorP1Controller({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              color: Constants.darkThemeColor,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 100,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 68,
                          ),
                          Constants.mediumWhiteTextWidget(
                              'P1 Training Mode', 24),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: Constants.screenWidth(context) - 48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Constants.mediumWhiteTextWidget(
                                    '45 seconds Game Time', 14,
                                    textAlign: TextAlign.left),
                                SizedBox(
                                  height: 8,
                                ),
                                Constants.regularGreyTextWidget(
                                    'Within 45 seconds after the start, the playershould aim to score as much as possible by engaging the challenges underdifferent modes. Execute precise movements and techniques to tackletraining challenges dynamically.',
                                    14,
                                    textAlign: TextAlign.start,
                                    height: 1.3),
                                SizedBox(height: 40,),
                                Constants.mediumWhiteTextWidget(
                                    'Initial assessment', 14,
                                    textAlign: TextAlign.left),
                                SizedBox(
                                  height: 8,
                                ),
                                Constants.regularGreyTextWidget(
                                    'In the initial 6 seconds of the 45 seconds after thestart, the player needs to score as much as possible. Depending on thescore within this period, two distinct training modes are initiated.',
                                    14,
                                    textAlign: TextAlign.start,
                                    height: 1.3),
                                SizedBox(height: 40,),
                              ],
                            ),
                          ),
                          RazorModeScrollView(),
                          SizedBox(height: 16,),
                        ],
                      ),
                    )),
                Positioned(
                  top: 16,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 模式切换锁定解除
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
                                image: AssetImage(
                                    'images/participants/back_grey.png'),
                                width: 16,
                                height: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 44,
                    left: 24,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {

                        // TTToast.showLoading();
                        // // NavigatorUtil.pop();
                        // // await SystemUtil.lockScreenHorizontalDirection();
                        // if (Platform.isAndroid) {
                        //   await SystemUtil.lockScreenHorizontalDirection();
                        //   // return;
                        // }
                        // GameUtil gameUtil = GetIt.instance<GameUtil>();
                        // gameUtil.selectRecord = false;
                        // await SystemUtil.resetScreenDirection();
                        List<CameraDescription> cameras = await availableCameras();
                        // NavigatorUtil.push(Routes.p3check, arguments: cameras[cameras.length >1 ? 1 : 0]);
                        // TTToast.hideLoading();
                        // BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, lightsControlData([0,0,1]));
                        // BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, ledControlData(13, 14));

                        // GameUtil gameUtil = GetIt.instance<GameUtil>();
                        // CommandManager.sendCommandsSequentially([motorControlData(motorStatus: [BleRazorMotorStatu.reversal,BleRazorMotorStatu.reversal],timers: [150,255]),motorControlData(motorStatus: [BleRazorMotorStatu.reversal,BleRazorMotorStatu.reversal],timers: [50,60])]);

                        //BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, motorControlData(motorStatus: [BleRazorMotorStatu.reversal,BleRazorMotorStatu.forward],timers: [100,200]));
                      //  BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, powerOffControlData());
                        NavigatorUtil.push(Routes.razorgameprocesspage,arguments: cameras[cameras.length >1 ? 1 : 0]);
                      },
                      child: Container(
                          width: Constants.screenWidth(context) - 48,
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
                            child:
                                Constants.boldBlackTextWidget('Continue', 16),
                          )),
                    ))
              ],
            ),
          ),
        ),
        onWillPop: () async {
          // 模式切换锁定解除
          return true;
        });
  }
}
