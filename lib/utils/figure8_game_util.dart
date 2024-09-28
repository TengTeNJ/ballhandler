// 第一阶段第三进度的红灯的灯控顺序
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../models/game/hit_target_model.dart';
import 'ble_data_service.dart';
import 'ble_ultimate_data.dart';
import 'ble_ultimate_service_data.dart';
import 'blue_tooth_manager.dart';
import 'control_time_out_util.dart';
import 'game_util.dart';
import 'global.dart';

// 第一阶段第三进度的红灯的灯控顺序
List<List<HitTargetModel>> thirdProcessRedData() {
  List<HitTargetModel> datas1 = [
    HitTargetModel(boardIndex: 5, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 5, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 5, ledIndex: 1, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 5, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas2 = [
    HitTargetModel(boardIndex: 0, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 1, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 1, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas3 = [
    HitTargetModel(boardIndex: 1, ledIndex: 1, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 1, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 1, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 1, ledIndex: 1, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
  return [datas1, datas2, datas3];
}

// 第一阶段第三进度的蓝灯的灯控顺序
List<List<HitTargetModel>> thirdProcessBlueData() {
  List<HitTargetModel> datas1 = [
    HitTargetModel(
        boardIndex: 5, ledIndex: 0, statu: BleULTimateLighStatu.blue),
  ];
  List<HitTargetModel> datas2 = [
    HitTargetModel(
        boardIndex: 3, ledIndex: 0, statu: BleULTimateLighStatu.blue),
    HitTargetModel(
        boardIndex: 0, ledIndex: 0, statu: BleULTimateLighStatu.blue),
  ];
  List<HitTargetModel> datas3 = [
    HitTargetModel(
        boardIndex: 1, ledIndex: 0, statu: BleULTimateLighStatu.blue),
  ];
  return [datas1, datas2, datas3];
}

class Figure8GameUtil {
  int _process3Index = 0; // 索引
  int _process3EveryUnitIndex = 0; // 每个单元的红灯索引
  int _countTime = 30; // 倒计时
  Timer? durationTimer;
  ValueNotifier<bool> isControl = ValueNotifier<bool>(false);

  Completer<bool> completer = Completer();
  static final Figure8GameUtil _instance = Figure8GameUtil._internal();

  factory Figure8GameUtil() {
    return _instance;
  }

  Figure8GameUtil._internal();

  Future<bool> startGame() async {
    this.completer = Completer();
    isControl.value = false;
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 监听击中
    BluetoothManager().p3DataChange = (BLEDataType type) async {
      if (type == BLEDataType.targetIn) {
        if(ControlTimeOutUtil().controling.value){
          return;
        }
        HitTargetModel? hitModel = BluetoothManager().gameData.hitTargetModel;
        // 获取击中的标靶
        // 第三进度
        // 取出来当前控制的led
        List<HitTargetModel> redDatas = thirdProcessRedData()[_process3Index];
        HitTargetModel currentModel = redDatas[_process3EveryUnitIndex];
        List<HitTargetModel> blueDatas = thirdProcessBlueData()[_process3Index];
        // 击中红灯
        if (hitModel != null &&
            hitModel.boardIndex == currentModel.boardIndex &&
            hitModel.ledIndex == currentModel.ledIndex &&
            hitModel.statu == BleULTimateLighStatu.red) {
          if(saveBoardHitMessgeId(hitModel)){
            return;
          }
          // 关闭当前灯
          controSingleLightBoard(currentModel.boardIndex,
              currentModel.ledIndex, BleULTimateLighStatu.close);
          //  响应击中的灯
          BluetoothManager().writerDataToDevice(
              gameUtil.selectedDeviceModel,responseHitModel(hitModel.boardIndex, BluetoothManager().hitModelMessageId));
          // 加分
          BluetoothManager().gameData.score =
              BluetoothManager().gameData.score + 2;
          // 得分显示
          BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
              scoreShow(BluetoothManager().gameData.score));
          // 开启下一个灯
          _process3EveryUnitIndex++;
          _process3Control();
        } else if (hitModel != null &&
            hitModel.statu == BleULTimateLighStatu.blue) {
          // 击中蓝灯
          HitTargetModel matchModel = blueDatas.firstWhere((element) =>
              hitModel != null &&
              hitModel.boardIndex == element.boardIndex &&
              hitModel.ledIndex == element.ledIndex);
          if (matchModel != null) {
            if(saveBoardHitMessgeId(hitModel)){
              return;
            }
            //  响应击中的灯
            BluetoothManager().writerDataToDevice(
                gameUtil.selectedDeviceModel,responseHitModel(hitModel.boardIndex, BluetoothManager().hitModelMessageId));
            // 减分
            BluetoothManager().gameData.score =
                BluetoothManager().gameData.score - 1;
            // 得分显示
            BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
                scoreShow(BluetoothManager().gameData.score));
          }
        }
      }
    };
    // 倒计时显示
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
    // 得分显示
    BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
        scoreShow(BluetoothManager().gameData.score));
    // 30秒倒计时
    this.durationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countTime--;
      // 倒计时显示
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
      if (_countTime <= 0) {
        // 倒计时显示
        if (isControl.value) {
          // sleep(Duration(milliseconds: 1000));
          isControl.addListener(controlListen);
        } else {
          BluetoothManager().writerDataToDevice(
              gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
          this.stopGame();
          listenControlutil(this.completer);
        }

      }
    });
    _process3Control();
    return completer.future;
  }

  controlListen() {
    handle();
  }

  handle() async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (!isControl.value) {
      print('移除isControl监听');
      isControl.removeListener(controlListen);
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
      this.stopGame();
      listenControlutil(this.completer);
    }
  }
  stopGame() async{
    if (this.durationTimer != null) {
      this.durationTimer!.cancel();
      this.durationTimer = null;
    }
    _process3Index = 0; // 索引
    _process3EveryUnitIndex = 0; // 每个单元的红灯索引
    _countTime = 30; // 倒计时
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, closeAllBoardLight());
  }

  // 第三进度控制
  _process3Control() async {
    isControl.value = true;
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (_process3Index >= thirdProcessRedData().length) {
      this.stopGame();
      listenControlutil(this.completer);
      return;
    }
    List<HitTargetModel> blueDatas = thirdProcessBlueData()[_process3Index];
    List<HitTargetModel> redDatas = thirdProcessRedData()[_process3Index];
    if (_process3EveryUnitIndex >= redDatas.length) {
      // 关闭所有的灯光
       BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, closeAllBoardLight());
       sleep(Duration(milliseconds: 100));
      _process3EveryUnitIndex = 0;
      _process3Index++;
      _process3Control();
      return;
    }

    // 蓝灯在循环阶段只开启一次
    if (_process3EveryUnitIndex == 0) {
      for(int i = 0; i < blueDatas.length; i++){
        HitTargetModel model = blueDatas[i];
        // add 亮的标靶
        await BluetoothManager().asyncWriterDataToDevice(
            gameUtil.selectedDeviceModel,
            controSingleLightBoard(
                model.boardIndex, model.ledIndex, model.statu));
      }
    }

    // 逐个开启红灯
    HitTargetModel redmodel = redDatas[_process3EveryUnitIndex];
    await BluetoothManager().asyncWriterDataToDevice(
        gameUtil.selectedDeviceModel,
        controSingleLightBoard(
            redmodel.boardIndex, redmodel.ledIndex, redmodel.statu));
    isControl.value = false;
  }
}
