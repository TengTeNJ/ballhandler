import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';
class BatteryView extends StatefulWidget {
  const BatteryView({super.key});

  @override
  State<BatteryView> createState() => _BatteryViewState();
}

class _BatteryViewState extends State<BatteryView> {
  int powerLevel = 5;
 bool inGamePage = false;
 late StreamSubscription subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!mounted){
      return;
    }
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    inGamePage = gameUtil.nowISGamePage;
    if(gameUtil.selectedDeviceModel != null && gameUtil.selectedDeviceModel.device != null){
      powerLevel = gameUtil.selectedDeviceModel.batteryLevel;
    }
    setState(() {

    });
    subscription = EventBus().stream.listen((event) {
      if (event == kCurrentDeviceInfoChange) {
        print('设备信息有变化');
        if(gameUtil.selectedDeviceModel != null && gameUtil.selectedDeviceModel.device != null){
          powerLevel = gameUtil.selectedDeviceModel.batteryLevel;
          print('gameUtil.selectedDeviceModel=${gameUtil.selectedDeviceModel.powerValue}');
        }
      }else if(event == kCurrent270DeviceInfoChange){
        // 获取270设备中电量最少的赋值个电量变量
        powerLevel = gameUtil.selectedDeviceModel.batteryLevel;
      }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return  inGamePage ?  Image(image: AssetImage('images/battery/level_${powerLevel}.png'),width: 30,height: 15,) : Image(image: AssetImage('images/battery/game_level_${powerLevel}.png'),width: 30,height: 15,);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
