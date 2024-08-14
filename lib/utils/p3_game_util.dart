import 'dart:async';

import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:get_it/get_it.dart';

import '../constants/constants.dart';
import 'ble_data_service.dart';
import 'blue_tooth_manager.dart';
import 'global.dart';

List<List<ClickTargetModel>> zigzagDatas() {
  // 先1号板子 0蓝 2红
  List<ClickTargetModel> oneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 3红
  List<ClickTargetModel> twoData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 1红
  List<ClickTargetModel> threeData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 2号板子 3红
  List<ClickTargetModel> fourData = [
    ClickTargetModel(
        boardIndex: 2, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 4号板子 3红
  List<ClickTargetModel> fiveData = [
    ClickTargetModel(
        boardIndex: 4, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 3号板子 2红
  List<ClickTargetModel> sixData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [2], statu: [BleULTimateLighStatu.red])
  ];
  // 0号板子 2红
  List<ClickTargetModel> sevenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [2], statu: [BleULTimateLighStatu.red])
  ];
  // 2号板子 3红
  List<ClickTargetModel> eightData = [
    ClickTargetModel(
        boardIndex: 2, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 4号板子 3红
  List<ClickTargetModel> nineData = [
    ClickTargetModel(
        boardIndex: 4, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 5号板子 0蓝 3红
  List<ClickTargetModel> tenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 1红
  List<ClickTargetModel> elevenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 2红
  List<ClickTargetModel> twelveData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 3红
  List<ClickTargetModel> thirteenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 4号板子 3红
  List<ClickTargetModel> fourteenData = [
    ClickTargetModel(
        boardIndex: 4, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 2号板子 3红
  List<ClickTargetModel> fifteenData = [
    ClickTargetModel(
        boardIndex: 2, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 0号板子 1红
  List<ClickTargetModel> sixteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [1], statu: [BleULTimateLighStatu.red])
  ];
  // 3号板子 1红
  List<ClickTargetModel> seventeenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [1], statu: [BleULTimateLighStatu.red])
  ];
  // 4号板子 3红
  List<ClickTargetModel> eighteenData = [
    ClickTargetModel(
        boardIndex: 4, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 2号板子 3红
  List<ClickTargetModel> nineteenData = [
    ClickTargetModel(
        boardIndex: 2, ledIndex: [3], statu: [BleULTimateLighStatu.red])
  ];
  // 1号板子 0蓝 1红
  List<ClickTargetModel> twentyData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 2红
  List<ClickTargetModel> twentyOneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 3红
  List<ClickTargetModel> twentyTwoData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  List<List<ClickTargetModel>> datas = [
    oneData,
    twoData,
    threeData,
    fourData,
    fiveData,
    sixData,
    sevenData,
    eightData,
    nineData,
    tenData,
    elevenData,
    twelveData,
    thirteenData,
    fourteenData,
    fifteenData,
    sixteenData,
    seventeenData,
    eighteenData,
    nineteenData,
    twentyData,
    twentyOneData,
    twentyTwoData
  ];
  return datas;
}
List<List<ClickTargetModel>> backHandDatas() {
  // 先1号板子 0蓝 3红
  List<ClickTargetModel> oneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 2红
  List<ClickTargetModel> twoData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 1红
  List<ClickTargetModel> threeData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 3红
  List<ClickTargetModel> fourData = [
    ClickTargetModel(
        boardIndex: 2, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  List<List<ClickTargetModel>> datas = [
    oneData,
    twoData,
    threeData,
    fourData,
  ];
  return datas;
}
List<List<ClickTargetModel>> oneHandDatas() {
  // 先3号板子  1红
  List<ClickTargetModel> oneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [3],
        statu: [BleULTimateLighStatu.red]),
  ];
  // 0号板子 0红
  List<ClickTargetModel> twoData = [
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0],
        statu: [BleULTimateLighStatu.red]),
  ];
  // 3号板子  1红
  List<ClickTargetModel> threeData =  [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [1],
        statu: [BleULTimateLighStatu.red]),
  ];
  // 0号板子 0红
  List<ClickTargetModel> fourData =  [
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0],
        statu: [BleULTimateLighStatu.red]),
  ];
  // 3号板子 0蓝色 3红
  List<ClickTargetModel> fiveData = [
    ClickTargetModel(
        boardIndex:3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝色 2红
  List<ClickTargetModel> sixData =  [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝色 1红
  List<ClickTargetModel> sevenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝色 3红
  List<ClickTargetModel> eightData =  [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝色 2红
  List<ClickTargetModel> nineData =  [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 5号板子  0蓝 1红
  List<ClickTargetModel> tenData =  [
    ClickTargetModel(
        boardIndex: 5, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 0号板子 0红 1蓝
  List<ClickTargetModel> elevenData = [
    ClickTargetModel(
        boardIndex:0,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.red, BleULTimateLighStatu.blue]),
  ];
  // 0号板子 0蓝 1红
  List<ClickTargetModel> twelveData = [
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 0号板子 0蓝 2红
  List<ClickTargetModel> thirteenData = [
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 0号板子 0蓝 3红
  List<ClickTargetModel> fourteenData = [
    ClickTargetModel(
        boardIndex: 4, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝色 1红
  List<ClickTargetModel> fifteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0l蓝 2红
  List<ClickTargetModel> sixteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 3红
  List<ClickTargetModel> seventeenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝 2红; 0号板子 0蓝
  List<ClickTargetModel> eighteenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0], statu: [BleULTimateLighStatu.blue])
  ];
  // 3号板子 0蓝 3红; 0号板子 0蓝
  List<ClickTargetModel> nineteenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0], statu: [BleULTimateLighStatu.blue])
  ];
  // 3号板子 0蓝 1红; 0号板子 0蓝
  List<ClickTargetModel> twentyData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0], statu: [BleULTimateLighStatu.blue])
  ];
  // 3号板子 0蓝 ; 0号板子 0蓝 2红
  List<ClickTargetModel> twentyOneData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝 ; 0号板子 0蓝 1红
  List<ClickTargetModel> twentyTwoData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 ; 0号板子 0蓝 3红
  List<ClickTargetModel> twentyThreeData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0], statu: [BleULTimateLighStatu.blue])
  ];

  // 3号板子 0蓝 2红 ; 0号板子 0蓝
  List<ClickTargetModel> twentyFourData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 3红 ; 0号板子 0蓝
  List<ClickTargetModel> twentyFiveData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 1红 ; 0号板子 0蓝
  List<ClickTargetModel> twentySixData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0], statu: [BleULTimateLighStatu.blue])
  ];

  // 3号板子 0蓝 ; 0号板子 0蓝 2红
  List<ClickTargetModel> twentySevenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 ; 0号板子 0蓝 1红
  List<ClickTargetModel> twentyEightData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 ; 0号板子 0蓝 3红
  List<ClickTargetModel> twentyNinetData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];

  // 3号板子 0蓝 2红色 ; 0号板子 0蓝
  List<ClickTargetModel> thirtyData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue])
  ];

  // 3号板子 0蓝 3红色 ; 0号板子 0蓝
  List<ClickTargetModel> thirtyOneData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue])
  ];

  // 3号板子 0蓝 1红色 ; 0号板子 0蓝
  List<ClickTargetModel> thirtyTwoData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue])
  ];

  List<List<ClickTargetModel>> datas = [
    oneData,
    twoData,
    threeData,
    fourData,
    fiveData,
    sixData,
    sevenData,
    eightData,
    nineData,
    tenData,
    elevenData,
    twelveData,
    thirteenData,
    fourteenData,
    fifteenData,
    sixteenData,
    seventeenData,
    eighteenData,
    nineteenData,
    twentyData,
    twentyOneData,
    twentyTwoData,
    twentyThreeData,
    twentyFourData,
    twentyFiveData,
    twentySixData,
    twentySevenData,
    twentyEightData,
    twentyNinetData,
    thirtyData,
    thirtyOneData,
    thirtyTwoData
  ];
  return datas;
}
List<List<ClickTargetModel>> througyTheLegsDatas() {
  // 先1号板子 0,1,2蓝 3红
  List<ClickTargetModel> oneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
  ];
  // 1号板子 0,1,2蓝 3红
  List<ClickTargetModel> twoData =  [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
  ];
  // 3号板子 0,2,3蓝 1红
  List<ClickTargetModel> threeData = [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0, 1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 3号板子 0,2,3蓝 1红;0号板子 1,2,3蓝 0红
  List<ClickTargetModel> fourData =[
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0, 1,2,3],
        statu: [BleULTimateLighStatu.red, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 5号板子 0,2,3蓝 1红;0号板子 1,2,3蓝 0红
  List<ClickTargetModel> fiveData =[
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.red, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 5号板子 0,2,蓝 1,3红;0号板子 1,2,3蓝 0红
  List<ClickTargetModel> sixData =[
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.red, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 3号板子 0,2,3,蓝 1红;0号板子 1,2,3蓝 0红
  List<ClickTargetModel> sevenData =[
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.red, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 3号板子 0,2,3,蓝 1红;
  List<ClickTargetModel> eightData =[
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red,BleULTimateLighStatu.blue,BleULTimateLighStatu.blue]),
  ];

  // 1号板子 0,1,2,蓝 13红;2号板子 3红
  List<ClickTargetModel> nineData =[
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0,1,2,3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.blue,BleULTimateLighStatu.blue,BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [3],
        statu: [BleULTimateLighStatu.red]),
  ];

  List<List<ClickTargetModel>> datas = [
    oneData,
    twoData,
    threeData,
    fourData,
    fiveData,
    sixData,
    sevenData,
    eightData,
    nineData
  ];
  return datas;
}
List<List<ClickTargetModel>> trianglesDatas() {
  // 先1号板子 0蓝 2红
  List<ClickTargetModel> oneData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 3红
  List<ClickTargetModel> twoData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 1号板子 0蓝 1红
  List<ClickTargetModel> threeData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 3号板子 0蓝 3红
  List<ClickTargetModel> fourData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝 2红
  List<ClickTargetModel> fiveData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝;0号板子 2红
  List<ClickTargetModel> sixData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0], statu: [BleULTimateLighStatu.blue]),
    ClickTargetModel(
        boardIndex: 2, ledIndex: [2], statu: [BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝 3红
  List<ClickTargetModel> sevenData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 1红
  List<ClickTargetModel> eightData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 3号板子 2红;0号板子 2蓝
  List<ClickTargetModel> nineData = [
    ClickTargetModel(
        boardIndex: 3, ledIndex: [2], statu: [BleULTimateLighStatu.red]),
    ClickTargetModel(
        boardIndex: 0, ledIndex: [2], statu: [BleULTimateLighStatu.blue])
  ];
  // 0号板子 0蓝 2红
  List<ClickTargetModel> tenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 1红
  List<ClickTargetModel> elevenData = [
    ClickTargetModel(
        boardIndex: 0,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 1红
  List<ClickTargetModel> twelveData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 2红
  List<ClickTargetModel> thirteenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 3红
  List<ClickTargetModel> fourteenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 5号板子 0蓝 1红
  List<ClickTargetModel> fifteenData = [
    ClickTargetModel(
        boardIndex: 5,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 0号板子 0蓝 1红
  List<ClickTargetModel> sixteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 2红
  List<ClickTargetModel> seventeenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,2], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 3红
  List<ClickTargetModel> eighteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,3], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 0号板子 0蓝 1红
  List<ClickTargetModel> nineteenData = [
    ClickTargetModel(
        boardIndex: 0, ledIndex: [0,1], statu: [BleULTimateLighStatu.blue,BleULTimateLighStatu.red])
  ];
  // 3号板子 0蓝 3红
  List<ClickTargetModel> twentyData = [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 3号板子 0蓝 2红
  List<ClickTargetModel> twentyOneData = [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];
  // 3号板子 0蓝 1红
  List<ClickTargetModel> twentyTwoData = [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  // 3号板子 0蓝 3红
  List<ClickTargetModel> twentyThreeData = [
    ClickTargetModel(
        boardIndex: 3,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  // 1号板子 0蓝 1红
  List<ClickTargetModel> twentyFourData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  // 1号板子 0蓝 2红
  List<ClickTargetModel> twentyFiveData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 2],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  // 1号板子 0蓝 3红
  List<ClickTargetModel> twentySixData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 3],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  // 1号板子 0蓝 1红
  List<ClickTargetModel> twentySevenData = [
    ClickTargetModel(
        boardIndex: 1,
        ledIndex: [0, 1],
        statu: [BleULTimateLighStatu.blue, BleULTimateLighStatu.red]),
  ];

  List<List<ClickTargetModel>> datas = [
    oneData,
    twoData,
    threeData,
    fourData,
    fiveData,
    sixData,
    sevenData,
    eightData,
    nineData,
    tenData,
    elevenData,
    twelveData,
    thirteenData,
    fourteenData,
    fifteenData,
    sixteenData,
    seventeenData,
    eighteenData,
    nineteenData,
    twentyData,
    twentyOneData,
    twentyTwoData,
    twentyThreeData,
    twentyFourData,
    twentyFiveData,
    twentySixData,
    twentySevenData
  ];
  return datas;
}
List<List<List<ClickTargetModel>>> p3ModeDatas = [
  zigzagDatas(),
  zigzagDatas(),
  zigzagDatas(),
  trianglesDatas(),
  backHandDatas(),
  througyTheLegsDatas(),
  zigzagDatas(),
  oneHandDatas(),
];


class P3GameManager {
  static final P3GameManager _instance = P3GameManager._internal();

  factory P3GameManager() {
    return _instance;
  }

  P3GameManager._internal();

  List<int> selectIndexDatas = []; //  270模式选择的组合的索引
  int currentInGameIndex = -1; // 选择的组合当前正在游戏中的索引(0,1,2,3,4,5,6,7,8)
  Timer? durationTimer;
  Timer? frequencyTimer;
  int _index = 0; // 某组合下某个元素的灯光组合进行的索引
  int _countTime = 0; // 倒计时

  Future<bool> startGame({currentInGameIndex = 0}) async {
    // 如果传入了当前的组合元素的索引 则重新赋值。不传的话 需要在执行方法前记得全局赋值 比如 P3GameManager().currentInGameIndex = 0;
    this.currentInGameIndex = currentInGameIndex;
    // 取出来 组合元素的所有的灯光组合数据
    List<List<ClickTargetModel>> _allDatas =
        p3ModeDatas[this.currentInGameIndex];

    Completer<bool> completer = Completer();

     int duration =
        kP3IndexAndDurationMap[this.currentInGameIndex]!['duration'] ?? 0;
    // int frequency =
    //     kP3IndexAndDurationMap[this.currentInGameIndex]!['frequency'] ?? 0;

    // 倒计时赋值
    _countTime = (duration / 1000).toInt();
    print('开始一轮游戏');
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 倒计时显示
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
    // 得分显示
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));

    // 监听击中
    BluetoothManager().p3DataChange = (BLEDataType type) async {
      if (type == BLEDataType.targetIn) {
        if (this.frequencyTimer != null) {
          this.frequencyTimer!.cancel();
        }
        // 取出来当前灯光的组合
        List<ClickTargetModel> datas = _allDatas[this._index];
        HitTargetModel? hitModel = BluetoothManager().gameData.hitTargetModel;
        if (hitModel != null) {
          ClickTargetModel matchModel = datas.firstWhere((element) =>
              element.ledIndex.contains(hitModel!.ledIndex) &&
              element.boardIndex == hitModel!.boardIndex);
          if (matchModel != null) {
            // 击中了当前亮的灯
            if (hitModel.statu == BleULTimateLighStatu.blue) {
              // 击中蓝灯 减1分
              BluetoothManager().gameData.score --;
              // 得分显示
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
            } else if (hitModel.statu == BleULTimateLighStatu.red) {
              // 击中红灯加2分
              BluetoothManager().gameData.score = BluetoothManager().gameData.score +  2;
              // 得分显示
              BluetoothManager().writerDataToDevice(
                  gameUtil.selectedDeviceModel, scoreShow(BluetoothManager().gameData.score));
              this._index++;
              if (this._index > _allDatas.length) {
                // 结束本组合中的某个模式
                if (this.durationTimer != null) {
                  this.durationTimer!.cancel();
                }
                if (this.frequencyTimer != null) {
                  this.frequencyTimer!.cancel();
                }
                completer.complete(true);
              } else {
                // 继续循环执行
                _implement(completer);
              }
            }
          }

        }
      }
    };

    // 初始化 当前组合元素整体时长定时器
    if (this.durationTimer != null) {
      this.durationTimer!.cancel();
      this.durationTimer = null;
    }
    // 倒计时定时器
    this.durationTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      // 达到时长 结束本组合元素的循环 进行下一个
      _countTime--;
      BluetoothManager().writerDataToDevice(
          gameUtil.selectedDeviceModel, cutDownShow(value: _countTime));
      // 倒计时显示
      if (_countTime == 0) {
        if (this.durationTimer != null) {
          this.durationTimer!.cancel();
        }
        if (this.frequencyTimer != null) {
          this.frequencyTimer!.cancel();
        }
        completer.complete(true);
      }
    });

    _implement(completer);

    return completer.future;
  }

  /*停止游戏*/
  stopGame() {
    // 清空定时器
    if (this.durationTimer != null) {
      this.durationTimer!.cancel();
      this.durationTimer = null;
    }
    if (this.frequencyTimer != null) {
      this.frequencyTimer!.cancel();
      this.frequencyTimer = null;
    }
    this._index = 0;
    this._countTime = 0;
    this.currentInGameIndex = -1;
    this._countTime = 0;

    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 先关闭所有的灯光
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());
    // 倒计时显示
    BluetoothManager().writerDataToDevice(
        gameUtil.selectedDeviceModel, cutDownShow(value: 0));
  }

  // 执行
  _implement(Completer<bool> completer) async {
    if (_countTime <= 0) {
      return;
    }
    print('this._index=======${this._index}');
    List<List<ClickTargetModel>> _allDatas =
        p3ModeDatas[this.currentInGameIndex];

    if (this._index >= _allDatas.length) {
      // 结束本组合中的某个模式
      if (this.durationTimer != null) {
        this.durationTimer!.cancel();
      }
      if (this.frequencyTimer != null) {
        this.frequencyTimer!.cancel();
      }
      completer.complete(true);
      return;
    }
    List<ClickTargetModel> datas = _allDatas[this._index];
    int frequency =
        kP3IndexAndDurationMap[this.currentInGameIndex]!['frequency'] ?? 0;
    // 先清空
    if (this.frequencyTimer != null) {
      this.frequencyTimer!.cancel();
      this.frequencyTimer = null;
    }
    this.frequencyTimer =
        Timer.periodic(Duration(milliseconds: frequency), (timer) {
      this._index++;
      // 递归
      _implement(completer);
    });

    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 先关闭所有的灯光
    BluetoothManager()
        .writerDataToDevice(gameUtil.selectedDeviceModel, closeAllBoardLight());

    datas.forEach((element) async {
      // 初始化灯板上的所有灯的状态都为关
      List<BleULTimateLighStatu> lightStatu = [
        BleULTimateLighStatu.close,
        BleULTimateLighStatu.close,
        BleULTimateLighStatu.close,
        BleULTimateLighStatu.close
      ];
      // 根据具体数据进行替换 开关和红蓝状态
      element.ledIndex.forEach((action) {
        int index = action;
        BleULTimateLighStatu statu =
            element.statu[element.ledIndex.indexOf(index)];
        lightStatu[index] = statu;
      });
      // 控制某灯板上的所有灯
      BluetoothManager().writerDataToDevice(gameUtil.selectedDeviceModel,
          controLightBoard(element.boardIndex, lightStatu));
    });
  }
}
