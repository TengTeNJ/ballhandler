import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/audio_player_util.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/ble_ultimate_data.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';
import '../../utils/system_device.dart';

class ReadyController extends StatefulWidget {
  const ReadyController({super.key});

  @override
  State<ReadyController> createState() => _ReadyControllerState();
}

class _ReadyControllerState extends State<ReadyController> {
  late StreamSubscription subscription;
  String centerText = 'READY';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      if (event == kGameReady && gameUtil.modelId == 3) {
        timerPeriodRefreshText();
        playLocalAudio('pre.wav');
      } else if (event == kGamePre) {
        // P1 P2的准备阶段
        setState(() {
          String value = BluetoothManager().gameData.preValue.toString();
          if (value == '0') {
            value = 'GO';
          }
          centerText = value;
        });
      }
    });
  }

  /*倒计时刷新*/
  timerPeriodRefreshText() {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    int count = 3;

    if (gameUtil.modelId == 3) {
      // p3模式才发送
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, cutDownAndGoShow(value: 3));
    }
    // 开始游戏前 重置定时器
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, resetTimer());
    setState(() {
      centerText = count.toString();
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      count--;
      setState(() {
        if (count == 0) {
          centerText = 'GO';
          if (gameUtil.modelId == 3) {
            // p3模式才发送
            BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
                cutDownAndGoShow(value: 3, isGo: true));
          }
          timer.cancel();
        } else {
          if (gameUtil.modelId == 3) {
            // p3模式才发送
            BluetoothManager().writerDataToDevice(
                gameUtil.selectedDeviceModel, cutDownAndGoShow(value: count));
          }
          centerText = count.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Center(
        child: Constants.boldWhiteTextWidget(centerText, 75),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
