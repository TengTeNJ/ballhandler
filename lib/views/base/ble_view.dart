import 'dart:async';
import 'dart:ffi';

import 'package:code/constants/constants.dart';
import 'package:flutter/material.dart';

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
      if (event == kCurrentDeviceDisconnected) {
        print('当前设备断开连接');
        connected = false;
        if(mounted){
          setState(() {

          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return connected
        ? Image(
            image: AssetImage('images/ble/game_ble.png'),
            width: 25,
            height: 25,
          )
        : Image(
            image: AssetImage('images/ble/game_ble.png'),
            width: 25,
            height: 25,
           color: Constants.baseGreyStyleColor,
          );
  }
}
