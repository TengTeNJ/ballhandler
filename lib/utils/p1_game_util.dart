import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:get_it/get_it.dart';

import '../constants/constants.dart';
import 'ble_data_service.dart';
import 'blue_tooth_manager.dart';
import 'global.dart';

// 第一阶段第一进度的灯控的顺序
List<HitTargetModel> firstProcessData() {
  return [
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
}

// 第一阶段第二进度的灯控顺序
List<List<HitTargetModel>> secondProcessData() {
  List<HitTargetModel> datas1 = [
    HitTargetModel(boardIndex: 5, ledIndex: 0, statu: BleULTimateLighStatu.blue),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
    // HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas2 = [
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas3 = [
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas4 = [
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas5 = [
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 4, ledIndex: 3, statu: BleULTimateLighStatu.red),
  ];
  List<HitTargetModel> datas6 = [
    HitTargetModel(boardIndex: 2, ledIndex: 3, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 3, ledIndex: 2, statu: BleULTimateLighStatu.red),
    HitTargetModel(boardIndex: 0, ledIndex: 2, statu: BleULTimateLighStatu.red),
  ];
  return [datas1, datas2, datas3, datas4, datas5, datas6];
}

// 第一阶段第三进度的红灯的灯控顺序
List<List<HitTargetModel>> thirdProcessRedData() {
  List<HitTargetModel> datas1 = [
    HitTargetModel(boardIndex: 5, ledIndex: 1, statu: BleULTimateLighStatu.red),
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

class P1GameManager {
  static final P1GameManager _instance = P1GameManager._internal();

  factory P1GameManager() {
    return _instance;
  }

  P1GameManager._internal();

  int stage = 1; // 阶段 值为1和2，代表第一和第二阶段，一共两个阶段 第一个阶段60秒，有三个小阶段，第二个阶段30秒 是随机阶段
  int firstStageProcess = 2; // 第一阶段的进度,1是亮点对拉 2是拖拽对拉 3是八字绕桩
  Timer? durationTimer;
  Timer? duration2Timer;
  Timer? frequencyTimer;
  int _countTime = 60; // 倒计时

  int _process1Index = 0; // 第一进度的索引
  int _process2Index = 0; // 第二进度的索引
  List<int> process2LedIndexs = []; // 第二进度 每次三个亮的标靶

  int _process3Index = 0; // 第三进度的索引
  int _stage2HitCount = 0; //  第二阶段 每次随机亮灯后击中的个数
  int _process3EveryUnitIndex = 0; // 第三阶段的每个单元的红灯索引
  List<HitTargetModel> randomTargets = []; // 第二阶段 随机亮的灯的数组 每次随机亮一个或者两个
  Future<bool> startGame() async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 开始游戏指令
    BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, gameStart());
    // 先关闭所有的灯光
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
    Completer<bool> completer = Completer();
    // 首先进入第一阶段 第一进度
    this.stage = 1;
    this.firstStageProcess = 1;

    // 倒计时显示
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
    // 得分显示
    BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
        scoreShow(BluetoothManager().gameData.score));

    // 监听击中
    BluetoothManager().p3DataChange = (BLEDataType type) async {
      if (type == BLEDataType.targetIn) {
        HitTargetModel? hitModel = BluetoothManager().gameData.hitTargetModel;
        print('击中----123--');
        // 获取击中的标靶
        // 第一阶段
        if (this.stage == 1) {
          if(this.firstStageProcess == 1){
            // 第一进度
            // 获取当前控制的亮的标靶
            HitTargetModel currentTraget = firstProcessData()[_process1Index];
            if(hitModel != null && hitModel!.boardIndex == currentTraget.boardIndex && hitModel!.ledIndex == currentTraget.ledIndex){
              // 击中
              // 加分
              BluetoothManager().gameData.score = BluetoothManager().gameData.score + 1;
              // 得分显示
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
              // 关闭击中的灯
             BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(currentTraget.boardIndex, currentTraget.ledIndex, BleULTimateLighStatu.close));
              // 下一个
              _process1Index ++;
              _process1Control();
            }
          }else if(this.firstStageProcess == 2){
            // 第二进度
            // 获取当前控制的亮的标靶
            List<HitTargetModel> datas  = secondProcessData()[_process2Index];
            // 获取是否是亮着的灯
            HitTargetModel matchModel = datas.firstWhere((element) => hitModel!=null && hitModel.boardIndex == element.boardIndex && hitModel.ledIndex == element.ledIndex && process2LedIndexs.contains(hitModel.ledIndex) );
            if(matchModel != null){
              // 代表集中
              process2LedIndexs.remove(hitModel!.ledIndex);
              // 关闭击中的灯
              BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(matchModel.boardIndex, matchModel.ledIndex, BleULTimateLighStatu.close));
              if(process2LedIndexs.length == 0){
                // 加分
                BluetoothManager().gameData.score = BluetoothManager().gameData.score + 3;
                // 得分显示
                BluetoothManager().writerDataToDevice(
                    gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
                _process2Index ++ ;
                _process2Control();
              }
            }
          }else if(this.firstStageProcess == 3){
            // 第三进度
            // 取出来当前控制的led
            List<HitTargetModel> redDatas = thirdProcessRedData()[_process3Index];
            HitTargetModel currentModel = redDatas[_process3EveryUnitIndex];
            List<HitTargetModel> blueDatas = thirdProcessBlueData()[_process3Index];
             // 击中红灯
            if(hitModel != null && hitModel.boardIndex == currentModel.boardIndex && hitModel.ledIndex == currentModel.ledIndex && hitModel.statu == BleULTimateLighStatu.red){
              // 关闭当前灯
              BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(currentModel.boardIndex, currentModel.ledIndex, BleULTimateLighStatu.close));
              // 加分
              BluetoothManager().gameData.score = BluetoothManager().gameData.score + 1;
              // 得分显示
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
              if(_process3EveryUnitIndex >= (redDatas.length - 1)){
                // 关闭所有的灯光
                BluetoothManager()
                    .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
                _process3Index ++ ;
                _process3EveryUnitIndex = 0;
                if(this.frequencyTimer != null){
                  this.frequencyTimer!.cancel();
                  this.frequencyTimer = null;
                }
                _process3Control();
              }else{
                // 开启下一个灯
                _process3EveryUnitIndex ++ ;
                HitTargetModel currentModel = redDatas[_process3EveryUnitIndex];
                this.frequencyTimer = Timer.periodic(Duration(milliseconds: 3500), (timer){
                  if(_process3EveryUnitIndex > redDatas.length){
                    // 进入第三季度的下一个单元
                    _process3Index ++;
                    _process3EveryUnitIndex = 0;
                    // 递归
                    _process3Control();
                  }else{
                    _process3EveryUnitIndex ++;
                    HitTargetModel redmodel = redDatas[_process3EveryUnitIndex];
                    if(_process3EveryUnitIndex >0){
                      HitTargetModel closemodel = redDatas[_process3EveryUnitIndex - 1];
                      // 关闭上个灯
                      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(closemodel.boardIndex, closemodel.ledIndex, BleULTimateLighStatu.close));
                    }
                    BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(redmodel.boardIndex, redmodel.ledIndex, redmodel.statu));
                  }
                });
                BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(currentModel.boardIndex, currentModel.ledIndex, currentModel.statu));
              }

            }else   if(hitModel != null && hitModel.statu == BleULTimateLighStatu.blue){
              // 击中蓝灯
              print('击中蓝灯了-------');
              HitTargetModel matchModel = blueDatas.firstWhere((element) => hitModel!=null && hitModel.boardIndex == element.boardIndex && hitModel.ledIndex == element.ledIndex);
              if(matchModel != null) {
                print('击中蓝灯了 减分-------');
                // 减分
                BluetoothManager().gameData.score = BluetoothManager().gameData.score - 1;
                // 得分显示
                BluetoothManager().writerDataToDevice(
                    gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
              }
            }
          }

        }else{
          // 第二阶段
          HitTargetModel matchModel = randomTargets.firstWhere((element) => hitModel!=null && element.boardIndex == hitModel.boardIndex && element.ledIndex == hitModel.ledIndex);
          print('第二阶段击中---------------');
          if(matchModel != null){
            _stage2HitCount ++ ;
            BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(matchModel.boardIndex, matchModel.ledIndex, BleULTimateLighStatu.close));
            if(_stage2HitCount == randomTargets.length){
              BluetoothManager().gameData.score = BluetoothManager().gameData.score + randomTargets.length;
              // 得分显示
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
              _randomControl();
            }
          }
        }
      }
    };
 // 第一进度60秒倒计时
    this.durationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _countTime--;
      // 倒计时显示
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
      if (_countTime <= 0) {
        // 60s结束后进入第二阶段
        this.stage = 2;
        this.durationTimer!.cancel();
        this.durationTimer = null;
        if(this.frequencyTimer != null){
          this.frequencyTimer!.cancel();
          this.frequencyTimer = null;
        }
        _countTime = 30;
        // 倒计时显示
        BluetoothManager().writerDataToDevice(
            gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
        this.duration2Timer = Timer.periodic(Duration(seconds: 1), (callback){
          // 进入第二阶段
          _countTime--;
          // 倒计时显示
          BluetoothManager().writerDataToDevice(
              gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
          if (_countTime <= 0) {
            this.duration2Timer!.cancel();
            this.duration2Timer = null;
            // 结束
            // 结束游戏指令
            BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, gameStart(onStart: false));
            completer.complete(true);
          }
        });
      }
    });
    // 第一进度开始控制
    _process1Control();
    return completer.future;
  }

  /*停止游戏*/
  stopGame() {}

  // 第一进度控制
  _process1Control(){
    if(_process1Index >= firstProcessData().length){
      // 进入第二进度
      this.firstStageProcess = 2;
      _process2Control();
    }else{
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      HitTargetModel model = firstProcessData()[_process1Index];
      print('-----------------控制第一进度--------------');
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(model.boardIndex, model.ledIndex, model.statu));
    }
  }

  // 第二进度控制
  _process2Control(){
    if(_process2Index >= secondProcessData().length){
      // 进入第三进度
      this.firstStageProcess = 3;
      _process3Control();
    }else{
      process2LedIndexs.clear();
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      List<HitTargetModel> datas  = secondProcessData()[_process2Index];
      // 同时开启三个红灯
      datas.forEach((model){
        // add 亮的标靶
        process2LedIndexs.add(model.ledIndex);
        print('-----------------控制第二进度--------------');
        BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(model.boardIndex, model.ledIndex, model.statu));
      });
    }
  }

  // 第三进度控制
  _process3Control(){
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 关闭所有的灯光
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
    if(_process3Index >= thirdProcessRedData().length){
      // 进入第三阶段
      if(this.durationTimer != null){
        this.durationTimer!.cancel();
        this.durationTimer = null;
      }
    }else{
      List<HitTargetModel> blueDatas  = thirdProcessBlueData()[_process3Index];
      //  开启蓝灯
      blueDatas.forEach((model){
        // add 亮的标靶
        BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(model.boardIndex, model.ledIndex, model.statu));
      });
      List<HitTargetModel> redDatas = thirdProcessRedData()[_process3Index];
      // 逐个开启红灯
      this.frequencyTimer = Timer.periodic(Duration(milliseconds: 3500), (timer){
        _process3EveryUnitIndex++;
        if(_process3EveryUnitIndex > (redDatas.length - 1)){
          // 关闭所有的灯光
          BluetoothManager()
              .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
         // BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(blue , ledIndex, statu))
          // 进入第三季度的下一个单元
          _process3Index ++;
          _process3EveryUnitIndex = 0;
          // 递归
          _process3Control();
        }else{
          HitTargetModel redmodel = redDatas[_process3EveryUnitIndex];
          if(_process3EveryUnitIndex >0){
            HitTargetModel closemodel = redDatas[_process3EveryUnitIndex - 1];
            // 关闭上个灯
            BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(closemodel.boardIndex, closemodel.ledIndex, BleULTimateLighStatu.close));
          }
          BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(redmodel.boardIndex, redmodel.ledIndex, redmodel.statu));
        }
      });
      // 开红灯
      HitTargetModel redmodel = redDatas[_process3EveryUnitIndex];
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(redmodel.boardIndex, redmodel.ledIndex, redmodel.statu));
    }
  }

  // 第二阶段 随机亮1个或者两个红灯阶段
  _randomControl(){
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 关闭所有的灯光
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
    var random = Random();
    // 先清空数组数据
    randomTargets.clear();
    // 生成一个0到10（包括0和10）的随机整数
    int randomCount = random.nextInt(2) + 0; //  生成随机的个数
    if(randomCount == 1){
      int randomBoardIndex = random.nextInt(6); // 生成一个0到5的数值 灯板索引为0-5
      int randomLedIndex;
      if(randomBoardIndex == 2 || randomBoardIndex == 4){
        // 2和4号板 只有一个led 索引为3 
        randomLedIndex = 3;
      }else{
        randomLedIndex = random.nextInt(4); // 生成一个0到3的数值 灯板索引为0-3
      }
      randomTargets.add(HitTargetModel(boardIndex: randomBoardIndex, ledIndex: randomLedIndex, statu: BleULTimateLighStatu.red));
    }else{
      int randomBoardIndex1 = random.nextInt(6); // 生成一个0到5的数值 灯板索引为0-5
      int randomLedIndex1;
      if(randomBoardIndex1 == 2 || randomBoardIndex1 == 4){
        // 2和4号板 只有一个led 索引为3
        randomLedIndex1 = 3;
      }else{
        randomLedIndex1 = random.nextInt(4); // 生成一个0到3的数值 灯板索引为0-3
      }
      int randomBoardIndex2 = random.nextInt(6); // 生成一个0到5的数值 灯板索引为0-5
      int randomLedIndex2;
      if(randomBoardIndex2 == 2 || randomBoardIndex2 == 4){
        // 2和4号板 只有一个led 索引为3
        randomLedIndex2 = 3;
      }else{
        randomLedIndex2 = random.nextInt(4); // 生成一个0到3的数值 灯板索引为0-3
      }
      while(randomLedIndex1 == randomLedIndex1 && randomBoardIndex1 == randomBoardIndex2 ){
           if(randomBoardIndex2 == 2 || randomBoardIndex2 == 4){
             randomBoardIndex2 = random.nextInt(6);
           }else{
             randomLedIndex2 = random.nextInt(4);
           }
      }
      HitTargetModel targetModel1 = HitTargetModel(boardIndex: randomBoardIndex1, ledIndex: randomLedIndex1, statu: BleULTimateLighStatu.red);
      HitTargetModel targetModel2 = HitTargetModel(boardIndex: randomBoardIndex2, ledIndex: randomLedIndex2, statu: BleULTimateLighStatu.red);
      randomTargets.add(targetModel1);
      randomTargets.add(targetModel2);
    }
    randomTargets.forEach((element){
      // 随机点亮灯
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel, controSingleLightBoard(element.boardIndex, element.ledIndex, element.statu));
    });
  }
}
