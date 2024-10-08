import 'dart:math';

import 'package:code/utils/ble_robot_data.dart';
import 'package:get_it/get_it.dart';

import '../models/game/hit_target_model.dart';
import 'ble_ultimate_data.dart';
import 'ble_ultimate_service_data.dart';
import 'blue_tooth_manager.dart';
import 'global.dart';

class P3RobotTestUtil {
  static final P3RobotTestUtil _instance = P3RobotTestUtil._internal();

  factory P3RobotTestUtil() {
    return _instance;
  }

  P3RobotTestUtil._internal();

  String randomIndex = '00';
  HitTargetModel randomModel = HitTargetModel(
      boardIndex: 0, ledIndex: 0, statu: BleULTimateLighStatu.close);
  List<int> randomIndexs = [];
  List<HitTargetModel> allLeds = [];

  initDatas() {
    if(!allLeds.isNotEmpty){
      allLeds.clear();
    }
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

  /*随机控灯*/
  randomControlLed() async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();

    // 先关闭
    await BluetoothManager().asyncWriterDataToDevice(
        gameUtil.selectedDeviceModel,
        controSingleLightBoard(randomModel.boardIndex, randomModel.ledIndex,
            BleULTimateLighStatu.close));

    var random = Random();
    if (allLeds.isNotEmpty) {
      initDatas();
    }
    int randomCount = random.nextInt(allLeds.length);
    String ledString = allLeds[randomCount].boardIndex.toString() +
        allLeds[randomCount].ledIndex.toString();
    while (ledString == randomCount) {
      randomCount = random.nextInt(allLeds.length);
      ledString = allLeds[randomCount].boardIndex.toString() +
          allLeds[randomCount].ledIndex.toString();
    }
    randomIndex = ledString;
    HitTargetModel element = allLeds[randomCount];
    randomModel = element;
    allLeds.remove(element);

    await BluetoothManager().asyncWriterDataToDevice(
        gameUtil.selectedDeviceModel,
        controSingleLightBoard(
            element.boardIndex, element.ledIndex, BleULTimateLighStatu.red));
    // 通知亮灯位置
    BluetoothManager().writerDataToDevice(
        BluetoothManager().robotModel, noticeRobotIndex(element));
  }
}
