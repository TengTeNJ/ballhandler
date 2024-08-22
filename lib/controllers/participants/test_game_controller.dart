import 'dart:async';
import 'dart:math';

import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/ble_data_service.dart';
import '../../utils/ble_ultimate_data.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/global.dart';

class TestGameController extends StatefulWidget {
  const TestGameController({super.key});

  @override
  State<TestGameController> createState() => _TestGameControllerState();
}

class _TestGameControllerState extends State<TestGameController> {
  Timer? perionTimer;
  List<int> ledIndexs = [];
  Timer? resetPerionTimer;
  List<HitTargetModel> randomLeds = [];
  List<HitTargetModel> allLeds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BluetoothManager().p3DataChange = (BLEDataType type) async {
      if (type == BLEDataType.targetIn) {
        HitTargetModel? hitModel = BluetoothManager().gameData.hitTargetModel;
        if (hitModel != null && hitModel!.statu == BleULTimateLighStatu.red) {
          randomControl();
        }
      }
    };

    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 4; j++) {
        if (i == 2 || i == 4) {
          if (j != 3) {
            continue;
          }
        }
        HitTargetModel model = HitTargetModel(
            boardIndex: i, ledIndex: j, statu: BleULTimateLighStatu.red);
        allLeds.add(model);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (perionTimer != null) {
      perionTimer!.cancel();
      perionTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Container(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BaseButton(
              title: '开始随机测试',
              onTap: () {
                resetPerionTimer =
                    Timer.periodic(Duration(seconds: 600), (timer) {
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      BluetoothManager().writerDataToDevice(
                          gameUtil.selectedDeviceModel, resetTimer());
                    });
                print('开始');
                randomControl();
              },
            ),
            BaseButton(
              title: '结束随机测试',
              onTap: () {
                print('结束');
                if (perionTimer != null) {
                  perionTimer!.cancel();
                  perionTimer = null;
                }
                if (resetPerionTimer != null) {
                  resetPerionTimer!.cancel();
                  resetPerionTimer = null;
                }
              },
            )
          ],
        ),),
      ),
    );
  }

  randomControl() {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (!randomLeds.isEmpty) {
      randomLeds.forEach((element) {
        BluetoothManager().writerDataToDevice(
            gameUtil.selectedDeviceModel,
            controSingleLightBoard(element.boardIndex, element.ledIndex,
                BleULTimateLighStatu.close));
      });
    }
    randomLeds.clear();
    ledIndexs.clear();
    if (perionTimer != null) {
      perionTimer!.cancel();
      perionTimer = null;
    }
    var random = Random();
    // 生成一个0到17（包括0）的随机整数

    for (int i = 0; i < 8; i++) {
      int randomCount = random.nextInt(18);
      while (ledIndexs.contains(randomCount)) {
        randomCount = random.nextInt(18);
      }
      ledIndexs.add(randomCount);
      randomLeds.add(allLeds[randomCount]);
    }
    randomLeds.forEach((element) {
      var random = Random();
      int randomNumber = random.nextInt(2);
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel,
          controSingleLightBoard(
              element.boardIndex,
              element.ledIndex,
              randomNumber == 0
                  ? BleULTimateLighStatu.red
                  : BleULTimateLighStatu.blue));
    });
    perionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      randomControl();
    });
  }
}
