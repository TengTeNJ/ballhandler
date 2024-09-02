import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:get_it/get_it.dart';
import '../models/game/light_ball_model.dart';
import 'package:code/utils/string_util.dart';
import 'dart:math';
import '../models/game/light_ball_model.dart';
import 'ble_ultimate_service_data.dart';
import 'control_time_out_util.dart';
import 'global.dart';

/*初始化灯光状态 和UI的状态模拟一致*/
List<LightBallModel> initUltimateLightModels() {
  List<LightBallModel> _list = [];
  List<double> _lefts = [
    0.0526,
    0.170,
    0.108,
    0.1177,
    0.145429,
    0.295,
    0.295,
    0.363,
    0.422,
    0.5512,
    0.611,
    0.673,
    0.673,
    0.835,
    0,
    0,
    0,
    0
  ];
  List<double> _rights = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.1150,
    0.108,
    0.170,
    0.0526
  ];
  List<double> _bottoms = [
    0.0842,
    0.0842,
    0.236,
    0.342,
    0.6712,
    0.818,
    0.5679,
    0.679,
    0.6956,
    0.6956,
    0.679,
    0.818,
    0.5679,
    0.6712,
    0.342,
    0.236,
    0.0842,
    0.0842
  ];

  for (int i = 0; i < _lefts.length; i++) {
    LightBallModel model = LightBallModel(color: Constants.baseLightRedColor);
    model.left = _lefts[i];
    model.right = _rights[i];
    model.bottom = _bottoms[i];
    model.show = true;
    if ([2, 7, 10, 13].contains(i)) {

      model.color = Constants.baseLightBlueColor;
    }
    _list.add(model);
  }
  return _list;
}


/*模拟灯控*/
List<LightBallModel> simulatorLighs() {
  List<int> group1 = [0, 1, 2, 3];
  List<int> group2 = [4];
  List<int> group3 = [5, 6, 7, 8];
  List<int> group4 = [9, 10, 11, 12];
  List<int> group5 = [13];
  List<int> group6 = [14, 15, 16, 17];
  List<List<int>> groups = [group1, group2, group3, group4, group5, group6];
  List<LightBallModel> _list = [];
  List<double> _lefts = [
    0.0526,
    0.170,
    0.108,
    0.1177,
    0.145429,
    0.295,
    0.295,
    0.363,
    0.422,
    0.5512,
    0.611,
    0.673,
    0.673,
    0.835,
    0,
    0,
    0,
    0
  ];
  List<double> _rights = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.1150,
    0.108,
    0.170,
    0.0526
  ];
  List<double> _bottoms = [
    0.0842,
    0.0842,
    0.236,
    0.342,
    0.6712,
    0.818,
    0.5679,
    0.679,
    0.6956,
    0.6956,
    0.679,
    0.818,
    0.5679,
    0.6712,
    0.342,
    0.236,
    0.0842,
    0.0842
  ];

  Random random = Random();
  int randomNumber1 = random.nextInt(6); // 生成第一个随机数，范围0到5
  int randomNumber2 = random.nextInt(6);
  while (randomNumber2 == randomNumber1) {
    randomNumber2 = random.nextInt(6);
  }
  int redFlag = 0;
  int blueFlg = 0;
  for (int i = 0; i < _lefts.length; i++) {
    LightBallModel model = LightBallModel(color: Constants.baseLightRedColor);
    model.left = _lefts[i];
    model.right = _rights[i];
    model.bottom = _bottoms[i];
    List list1 = groups[randomNumber1];
    List list2 = groups[randomNumber2];
    if (list1.contains(i) || list2.contains(i)) {
      model.show = true;
      int random1 = random.nextInt(2); // 生成第一个随机数，范围0到5
      if (random1 == 0) {
        blueFlg++;
        if (blueFlg >= 3) {
          blueFlg = 0;
          random1 = 1;
        }
      } else {
        redFlag++;
        if (redFlag >= 3) {
          redFlag = 0;
          random1 = 0;
        }
      }
      model.color =
          [Constants.baseLightBlueColor, Constants.baseLightRedColor][random1];
    } else {
      model.show = false;
    }
    _list.add(model);
  }
  return _list;
}

/*初始化灯光状态数据数组*/
List<LightBallModel> initLighs() {

  List<LightBallModel> _list = [];
  List<double> _lefts = [
    0.0526,
    0.170,
    0.108,
    0.108,
    0.145429,
    0.295,
    0.295,
    0.363,
    0.422,
    0.5512,
    0.611,
    0.673,
    0.673,
    0.835,
    0,
    0,
    0,
    0
  ];
  List<double> _rights = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.108,
    0.108,
    0.170,
    0.0526
  ];
  List<double> _bottoms = [
    0.0842,
    0.0842,
    0.236,
    0.342,
    0.6712,
    0.818,
    0.5679,
    0.679,
    0.679,
    0.679,
    0.679,
    0.818,
    0.5679,
    0.6712,
    0.342,
    0.236,
    0.0842,
    0.0842
  ];
  for (int i = 0; i < _lefts.length; i++) {
    LightBallModel model = LightBallModel(color: Constants.baseLightRedColor);
    model.left = _lefts[i];
    model.right = _rights[i];
    model.bottom = _bottoms[i];
    model.index = i;
    _list.add(model);
  }
  return _list;
}

/*解析所有的灯板的每个灯的状态*/
List<BleULTimateLighStatu> parseAllLedStatu(List<int> element) {
  if (element.isEmpty || element.length < 10) {
    print('处理每个灯板的状态时数据不正确');
    return [];
  }
  List<BleULTimateLighStatu> _tempLists = [];
  for (int i = 10; i >= 5; i--) {
    int board5 = element[i]; // 板子0
    String bits = StringUtil.decimalToBinary(board5);
    String board3 = bits.substring(0, 2); // 灯板3的状态
    String board2 = bits.substring(24); // 灯板2的状态
    String board1 = bits.substring(4, 6); // 灯板1的状态
    String board0 = bits.substring(6, 8); // 灯板0的状态
    late List<BleULTimateLighStatu> boardLightStatus;
    if (i == 4 || i == 1) {
      boardLightStatus = [
        StringUtil.lightToStatu(board0),
      ];
    } else {
      boardLightStatus = [
        StringUtil.lightToStatu(board0),
        StringUtil.lightToStatu(board1),
        StringUtil.lightToStatu(board2),
        StringUtil.lightToStatu(board3)
      ];
    }

    _tempLists.addAll(boardLightStatus);
  }
  return _tempLists;
}

String getGameDutation(){
  GameUtil gameUtil = GetIt.instance<GameUtil>();
  if(gameUtil.gameScene == GameScene.five){
    // 五节
    return '45';
  }else if(gameUtil.gameScene == GameScene.erqiling){
    // 270
    if(gameUtil.modelId == 1){
      return kP1Duration.toString();
    }else if(gameUtil.modelId == 2){
      return kP2Duration.toString();
    }else{
      List<int> indexs = gameUtil.selectdP3Indexs;
      int duration = 0;
      indexs.forEach((element){
        Map? _map = kP3IndexAndDurationMap[element];
        if(_map != null){
          int _duration = _map['duration'];
          duration = duration + _duration;
        }

      });
      String durationString = (duration/1000).toInt().toString();
      return durationString;
    }
  }
  return '45';
}

/*P3模式倒计时结束或者进行下一个组合游戏时监听确认是否上一个控制未返回*/
listenControlutil(Completer<bool> completer) {
  if (!ControlTimeOutUtil().controling.value) {
    completer.complete(true);
  } else {
    // 监听此时是否正在控制
    ControlTimeOutUtil().controling.addListener(() {
      if (!ControlTimeOutUtil().controling.value) {
        ControlTimeOutUtil().controling.removeListener(() {});
        completer.complete(true);
      }
    });
  }
}

