/*
* 270度训练模式页面状态栏
* */
import 'dart:async';

import 'package:code/models/ble/ble_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../constants/constants.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/notification_bloc.dart';

class DeviceStatuView extends StatefulWidget {
  const DeviceStatuView({super.key});

  @override
  State<DeviceStatuView> createState() => _DeviceStatuViewState();
}

class _DeviceStatuViewState extends State<DeviceStatuView> {
  List<int> batteryValues = [];
  bool connected = false;
  List<String> imageNames = ['gray', 'red', 'yellow', 'green'];
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryAndBlestatuValues();
    // 监听设备信息变化
    subscription = EventBus().stream.listen((event) {
      if (event == kCurrent270DeviceInfoChange) {
        if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
          return;
        }
        BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
        if (model.deviceName.contains(k270_Name)) {
          getBatteryAndBlestatuValues();
        }
      } else if (event == kDeviceConnected) {
        if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
          return;
        }
        BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
        if (model.deviceName.contains(k270_Name)) {
          connected = true;
        }
      } else if (event == kInitiativeDisconnectUli ||
          event == kCurrentDeviceDisconnectedUli) {
        connected = false;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  /*查询蓝牙连接状态和电量信息*/
  getBatteryAndBlestatuValues() {
    if (!BluetoothManager().hasConnectedDeviceList.isEmpty) {
      BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
      if (model.deviceName.contains(k270_Name)) {
        connected = true;
      }
    }
    batteryValues.clear();
    batteryValues.addAll(BluetoothManager().gameData.p3DeviceBatteryValues);
  }

  Widget _itemBuilder(BuildContext context, int index) {
    List<int> _values = [batteryValues[1],batteryValues[2],batteryValues[3],batteryValues[0],batteryValues[4],batteryValues[5]];
    int value = _values[index];
    int nameIndex = 0;
    if (BluetoothManager().hasConnectedDeviceList.isEmpty || !connected) {
      nameIndex = 0;
    } else if (value <= 25) {
      nameIndex = 1;
    } else if (value > 25 && value <= 75) {
      nameIndex = 2;
    } else {
      nameIndex = 3;
    }
    return Image(
      image: AssetImage('images/battery/battery_${imageNames[nameIndex]}.png'),
      width: 6,
      height: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 12,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: _itemBuilder,
              separatorBuilder: (context, index) => SizedBox(
                    width: 2,
                  ),
              itemCount: batteryValues.length),
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
