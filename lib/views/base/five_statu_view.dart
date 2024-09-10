/*
* 五节训练模式页面状态栏
* */
import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/ble/ble_model.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/notification_bloc.dart';
class FiveStatuView extends StatefulWidget {
  const FiveStatuView({super.key});

  @override
  State<FiveStatuView> createState() => _FiveStatuViewState();
}

class _FiveStatuViewState extends State<FiveStatuView> {
  List<int> batteryValues = [100, 100, 100, 100, 100, 100];
  bool connected = false;
  List<String> imageNames = ['gray', 'red', 'yellow', 'green'];
  String batteryImageName = 'gray';
  late StreamSubscription subscription;
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryAndBlestatuValues();
    subscription = EventBus().stream.listen((event) {
      if (event == kCurrentDeviceInfoChange) {
        BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
        if (model.deviceName.contains(kFiveBallHandler_Name)) {
          getBatteryAndBlestatuValues();
        }
      }else if(event == kDeviceConnected){
        BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
        if (model.deviceName.contains(kFiveBallHandler_Name)) {
          connected = true;
          batteryImageName = 'green';
        }
      }else if(event == kInitiativeDisconnectFive || event == kCurrentDeviceDisconnectedFive){
        connected = false;
        batteryImageName = 'gray';
      }
      if(mounted){
        setState(() {

        });
      }
    });
  }

  /*查询蓝牙连接状态和电量信息*/
  getBatteryAndBlestatuValues() {
    if (!BluetoothManager().hasConnectedDeviceList.isEmpty) {
      BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
      if (model.deviceName.contains(kFiveBallHandler_Name)){
        connected = true;
        int nameIndex = 3;
        int value = BluetoothManager().gameData.powerValue;
        if (value <= 20) {
          nameIndex = 1;
        } else if (value > 20 && value <= 70) {
          nameIndex = 2;
        } else {
          nameIndex = 3;
        }
        batteryImageName = imageNames[nameIndex];
      }
    }else{
      batteryImageName = 'gray';
    }
    if(mounted){
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage('images/battery/battery_five_${batteryImageName}.png'),
          width: 24,
          height: 12,
        ),
        SizedBox(
          width: 8,
        ),
        Image(
          image: AssetImage(
              connected ? 'images/ble/ble_on.png' : 'images/ble/ble_off.png'),
          width: 9,
          height: 12,
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
