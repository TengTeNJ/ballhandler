
import 'dart:async';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/razor_control_util.dart';

import '../constants/constants.dart';
import '../models/ble/ble_model.dart';
import 'ble_util.dart';
import 'navigator_util.dart';
import 'notification_bloc.dart';
/*数码管显示*/
const int ledControl = 0x01;
/*灯光控制*/
const int lightControl = 0x02;
/*电机控制*/
const int motorControl = 0x03;
/*关机*/
const int powerOff = 0x04;
/*app上下线*/
const int appOnline = 0x05;
/*电量上报*/
const int batteryLevelResponse = 0x06;
/*心跳上报*/
const int heartBeatResponse = 0x07;
/*击中上报*/
const int hitResponse = 0x08;
/*档位上报*/
const int gearResponse = 0x09;
/*点击控制完成上报*/
const int motorFinishResponse = 0x0a;
/*电机状态
* 正转 反转 停转
* */
enum BleRazorMotorStatu {stop,forward,reversal}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
Timer? delayTimer;

/*蓝牙数据解析类*/
class BleRazorServiceData {
  // 数据解析
  static parseData(List<int> data, BLEModel model) {
    if (data.isEmpty) {
      return;
    }
    if (data.length >= 4 && data[0] == kBLEDataFrameRazorHeader) {
      // 取出来数据的长度标识位
      int length = data[1];
      // 通过 帧头 帧尾 length数据位的值和实际的数据包length进行匹配
      if (data.length >= length && data[length - 1] == kBLEDataFramerFoot) {
        List<int> rightData = data.sublist(0, length);
        handleData(rightData, model); // 完整的一帧数据
        List<int> othersData = data.sublist(length, data.length);
        isNew = true;
        bleNotAllData.clear();
        if (delayTimer != null) {
          delayTimer!.cancel();
        }
        if (!othersData.isEmpty) {
          parseData(othersData, model);
        }
      } else {
        handleNotFullData(data, model);
      }
    } else {
      handleNotFullData(data, model);
    }
  }

  static handleNotFullData(List<int> data, BLEModel model) {
    bleNotAllData.addAll(data);
    if (isNew) {
      isNew = false;
      delayTimer = Timer(Duration(milliseconds: 150), () {
        if (!isNew) {
          print(
              '解析数据超时 ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
          // print(Œ
          //     'bleNotAllData.toString()} == ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}}');
          bleNotAllData.clear();
          isNew = true;
        }
      });
    } else {
      // print('handleNotFullData3${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
      if (bleNotAllData.length >= 4 &&
          bleNotAllData[0] == kBLEDataFrameRazorHeader) {
        int length = bleNotAllData[1];
        if (bleNotAllData.length >= length &&
            bleNotAllData[length - 1] == kBLEDataFramerFoot) {
          List<int> rightData = bleNotAllData.sublist(0, length);
          handleData(rightData, model); // 完整的一帧数据
          List<int> othersData =
          bleNotAllData.sublist(length, bleNotAllData.length);
          isNew = true;
          bleNotAllData.clear();
          if (delayTimer != null) {
            delayTimer!.cancel();
          }
          if (!othersData.isEmpty) {
            parseData(othersData, model);
          }
        }
      }
    }
  }

  static handleData(List<int> element, BLEModel mode) {
    if (element.length < 4) {
      // print('解析数据出错');
      return;
    }
    // 去除帧头
    element = element.sublist(1, element.length);
    // 数据源地址
    int cmd = element[1];
    // int id = element[2]; 暂且不需要重传机制 不需要id
    switch (cmd){
      case ledControl:
        // 数码管APP控制回复
        // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('数码管APP控制回复');
        break;
      case lightControl:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('灯光APP控制回复');
        break;
      case motorControl:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('电机APP控制回复');
        break;
      case powerOff:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('关机APP控制回复');
        break;
      case appOnline:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('上下线APP控制回复');
        break;
      case batteryLevelResponse:
      // 电量
        int value = element[2];
        print('电量=${value}');
        BluetoothManager().gameData.powerValue = value;
        BleUtil.listenPowerValue(NavigatorUtil.utilContext, value);
        EventBus().sendEvent(kCurrentDeviceInfoChange);
        break;
      case heartBeatResponse:
      // 心跳上报
        int value = element[2];
        print('心跳上报=${value}');
        break;
      case hitResponse:
      // 击打上报 0b0000 0001（如bit1:1号，0无 1击打）
        List<int> datas = [1,2,4]; // 因为只有三个灯板 所以只有可能00000001 00000010 00000100 三种二进制的值 ，对应10进制分别为 1  2 4
        int value = element[2];
        String binaryString = value.toRadixString(2).padLeft(8, '0');
        print('击打上报=${binaryString}');
        print('击中了${datas.indexOf(value) + 1}号灯板');
        break;
      case gearResponse:
      // 档位按下上报
        int value = element[2];
        print('档位按下上报=${value}');
        break;
      case motorFinishResponse:
      // 电机控制完成上报
        int value = element[2];
        print('电机控制完成上报=${value}');
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
