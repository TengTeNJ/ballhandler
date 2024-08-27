/*响应数据的CMD*/
import 'package:code/constants/constants.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:get_it/get_it.dart';

import '../models/ble/ble_model.dart';
import 'global.dart';

enum BLEDataType {
  none,
  dviceInfo,
  targetResponse,
  score,
  gameStatu,
  remainTime,
  millisecond,
  targetIn,
  boardHit, // 灯板击中 270
  statuSynchronize, // 状态同步 270
  scoreAndRemainTime, // 270得分和倒计时都变化
  allBoardStatuOneByOne, // 所有的灯板状态的数据的一个个灯板进行解析，此时不能刷新页面
  allBoadrStatuFinish, // 所有的灯板状态的数据解析完成，此时可以刷新页面
  refreshSingleLedStatu, // 刷新某面板上的单个灯光
  masterStatu, // Central主机当前的系统状态：1字节0: 系统初始化；1: 系统配网；2: 系统游戏；3: 系统设置；4: 系统管理
  onLine, // 在线状态
}
class ResponseCMDType {
  static const int deviceInfo = 0x20; // 设备信息，包含开机状态、电量等
  static const int targetResponse = 0x26; // 标靶响应
  static const int score = 0x28; // 得分
  static const int gameStatu = 0x2A; // 游戏状态:开始和结束
  static const int remainTime = 0x2C; // 游戏剩余时长
  static const int millisecond = 0x32; // 游戏毫秒时间同步
  static const int targetIn = 0x10; // 目标集中
}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
/*蓝牙数据解析类*/
class BluetoothDataParse {
  // 数据解析
  static parseData(List<int> data, BLEModel model) {
    if (data.contains(kBLEDataFrameHeader)) {
      List<List<int>> _datas = splitData(data);
      _datas.forEach((element) {
        if (element == null || element.length == 0) {
          // 空数组
         // print('问题数据${element}');
        } else {
          // 先获取长度
          int length = element[0] - 1; // 获取长度 去掉了枕头
          if(length != element.length ){
            // 说明不是完整数据
            bleNotAllData.addAll(element);
            if(bleNotAllData[0] - 1 == bleNotAllData.length){
              print('组包1----${element}');
              handleData(bleNotAllData,model);
              isNew = true;
              bleNotAllData.clear();
            }else{
              isNew = false;
              Future.delayed(Duration(milliseconds: 10),(){
                if(!isNew){
                  bleNotAllData.clear();
                }
              });
            }
          }else{
            handleData(element,model);
          }

        }
      });
    } else {
        bleNotAllData.addAll(data);
        if(bleNotAllData[0] - 1 == bleNotAllData.length){
          print('组包2----${data}');
          handleData(bleNotAllData,model);
          isNew = true;
          bleNotAllData.clear();
        }else{
          isNew = false;
          Future.delayed(Duration(milliseconds: 10),(){
            if(!isNew){
              bleNotAllData.clear();
            }
          });
        }
      print('蓝牙设备响应数据不合法=${data}');
    }
  }
  static handleData(List<int> element,BLEModel mode){
    int cmd = element[1];
    switch (cmd) {
      case ResponseCMDType.deviceInfo:
        int parameter_data = element[2];
        int statu_data = element[3];
        // 获取是哪个已连接的设备
        List<BLEModel>_list = BluetoothManager().hasConnectedDeviceList.where((element) =>   element.device!= null && (element.device!.id == mode.device!.id)).toList();
        BLEModel currentDevice = _list.first;
        if (parameter_data == 0x01) {
          // 开关机
          BluetoothManager().gameData.powerOn = (statu_data == 0x01);
          currentDevice.powerOn = (statu_data == 0x01);
        } else if (parameter_data == 0x02) {
          // 电量
          BluetoothManager().gameData.powerValue = statu_data;
          currentDevice.powerValue = statu_data;
          print('电量=======${statu_data}');
        }
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        // 说明是当前选择的游戏设备
        if(gameUtil.selectedDeviceModel.device != null && gameUtil.selectedDeviceModel.device!.id == mode.device!.id){
          EventBus().sendEvent(kCurrentDeviceInfoChange);
        }

        break;
      case ResponseCMDType.targetResponse:
      // 在游戏页面 才处理数据
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (!gameUtil.nowISGamePage) {
          return;
        }
        int data = element[2];
       // print('------data=${element}');
        String binaryString = data.toRadixString(2); // 转换成二进制字符串
        if (binaryString != null && binaryString.length == 8) {
          // 前两位都是1，不区分红灯和蓝灯，截取后边6位，判断哪个灯在亮
          final sub_string = binaryString.substring(2, 8);
          //print('sub_string=${sub_string}');
          final ligh_index = sub_string.indexOf('1');
          final actual_index = 5 - ligh_index + 1;
          BluetoothManager().gameData.currentTarget = kLighMap[actual_index] ?? 1;
          print('${kLighMap[actual_index]}号灯亮了');
          // print('binaryString=${binaryString}');
          BluetoothManager().triggerCallback(type: BLEDataType.targetResponse);
        }
        break;
      case ResponseCMDType.score:
      // 在游戏页面 才处理数据
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (!gameUtil.nowISGamePage) {
          return;
        }
        int data = element[2];
        BluetoothManager().gameData.score = data;
        // 通知
        print(
            'BluetoothManager().dataChange=${BluetoothManager().dataChange}');
        BluetoothManager().triggerCallback(type: BLEDataType.score);
        // print('${data}:得分');
        break;
      case ResponseCMDType.gameStatu:
      // 在游戏页面 才处理数据
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (!gameUtil.nowISGamePage) {
          return;
        }
        int data = element[2];
        BluetoothManager().gameData.gameStart = (data == 0x01);
        // print('游戏状态---${data}');
        BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
        break;
      case ResponseCMDType.remainTime:
      // 在游戏页面 才处理数据
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (!gameUtil.nowISGamePage) {
          return;
        }
        int data = element[2];
        BluetoothManager().gameData.remainTime = data;
        BluetoothManager().triggerCallback(type: BLEDataType.remainTime);
        break;
      case ResponseCMDType.millisecond:
      // 在游戏页面 才处理数据
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (!gameUtil.nowISGamePage) {
          return;
        }
        int data = element[2];
        BluetoothManager().gameData.millSecond = data;
        //  print('毫秒刷新---${data}');
        BluetoothManager().triggerCallback(type: BLEDataType.millisecond);
        break;
      case ResponseCMDType.targetIn:
        int data = element[2];
        print('目标击中--${data}');
        break;
    }
  }
}

/*数据拆分*/
List<List<int>> splitData(List<int> _data) {
  int a = kBLEDataFrameHeader;
  List<List<int>> result = [];
  int start = 0;
  while (true) {
    int index = _data.indexOf(a, start);
    if (index == -1) break;
    List<int> subList = _data.sublist(start, index);
    result.add(subList);
    start = index + 1;
  }
  if (start < _data.length) {
    List<int> subList = _data.sublist(start);
    result.add(subList);
  }
  return result;
}
