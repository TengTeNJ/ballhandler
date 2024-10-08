import 'dart:async';

import 'package:code/utils/color.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/ble/ble_model.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/notification_bloc.dart';

class NewBatteryView extends StatefulWidget {
  const NewBatteryView({super.key});

  @override
  State<NewBatteryView> createState() => _NewBatteryViewState();
}

class _NewBatteryViewState extends State<NewBatteryView> {
  List<int> batteryValues = [100,100,100,100,100,100];
  bool connected = false;
  List<String> imageNames = ['gray', 'red', 'yellow', 'green'];
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryValues();
    subscription = EventBus().stream.listen((event) {
      BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
      if (model.deviceName.contains(k270_Name)) {
        if (event == kCurrent270DeviceInfoChange) {
          getBatteryValues();
        } else if (event == kDeviceConnected) {
          connected = true;
        } else if (event == kInitiativeDisconnect ||
            event == kCurrentDeviceDisconnected) {
          connected = false;
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  getBatteryValues() {
    batteryValues.clear();
    BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
    if (model.deviceName.contains(k270_Name)) {
      connected = true;
    }
    batteryValues.addAll(BluetoothManager().gameData.p3DeviceBatteryValues);
    setState(() {});
  }

  Widget _itemBuilder(BuildContext context, int index) {
    List<int> _values = [
      batteryValues[1],
      batteryValues[2],
      batteryValues[3],
      batteryValues[0],
      batteryValues[4],
      batteryValues[5]
    ];
    int value = _values[index];
    int nameIndex = 0;
    if (!connected) {
      nameIndex = 0;
    } else if (value <= 25) {
      nameIndex = 1;
    } else if (value > 25 && value <= 75) {
      nameIndex = 2;
    } else {
      nameIndex = 3;
    }
    return Container(
      width: 8,
      height: 16,
      child: Image(
        image:
            AssetImage('images/battery/battery_${imageNames[nameIndex]}.png'),
        width: 8,
        height: 16,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: 12,right:12,top: 3,bottom: 3),
        scrollDirection: Axis.horizontal,
        itemBuilder: _itemBuilder,
        separatorBuilder: (context, index) => SizedBox(
          width: 6,
        ),
        itemCount: batteryValues.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
