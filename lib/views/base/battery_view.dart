import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/ble/ble_model.dart';
import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';

class BatteryView extends StatefulWidget {
  const BatteryView({super.key});

  @override
  State<BatteryView> createState() => _BatteryViewState();
}

class _BatteryViewState extends State<BatteryView> {
  int powerLevel = 0;
  bool inGamePage = false;
  bool connected = false;
  List<String> imageNames = ['gray', 'red', 'yellow', 'green'];
  String batteryImageName = 'gray';
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mounted) {
      return;
    }
    getBatteryAndBlestatuValues();
    subscription = EventBus().stream.listen((event) {
      if (event == kCurrentDeviceInfoChange) {
        getBatteryAndBlestatuValues();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('images/battery/battery_five_${batteryImageName}.png'),
      width: 24,
      height: 12,
      fit: BoxFit.contain,
    );
  }

  /*查询蓝牙连接状态和电量信息*/
  getBatteryAndBlestatuValues() {
    if (!BluetoothManager().hasConnectedDeviceList.isEmpty) {
      BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
      if (model.deviceName.contains(kFiveBallHandler_Name)) {
        connected = true;
        int nameIndex = 0;
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
    } else {
      batteryImageName = 'gray';
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
