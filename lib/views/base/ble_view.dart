import 'dart:async';
import 'dart:ffi';

import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

import '../../models/ble/ble_model.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/notification_bloc.dart';

class BLEView extends StatefulWidget {
  const BLEView({super.key});

  @override
  State<BLEView> createState() => _BLEViewState();
}

class _BLEViewState extends State<BLEView> {
  bool connected = true;
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) {
      if (event == kDeviceConnected) {
        if (!BluetoothManager().hasConnectedDeviceList.isEmpty) {
          BLEModel model = BluetoothManager().hasConnectedDeviceList.first;
          if (model.deviceName.contains(kFiveBallHandler_Name)) {
            connected = true;
          }
        }

      } else if (event == kInitiativeDisconnectFive ||
          event == kCurrentDeviceDisconnectedFive) {
        connected = false;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: connected
          ? Image(
              image: AssetImage('images/ble/ble_on.png'),
              width: 10,
              height: 12,
              fit: BoxFit.fill,
            )
          : Image(
              image: AssetImage('images/ble/ble_off.png'),
              width: 10,
              height: 12,
              fit: BoxFit.fill,
            ),
    );
  }
}
