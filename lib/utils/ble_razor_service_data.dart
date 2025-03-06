
import 'dart:async';
import 'package:code/utils/razor_control_util.dart';

import '../constants/constants.dart';
import '../models/ble/ble_model.dart';
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
    if (data.length >= 4 && data[0] == kBLEDataFrameHeader) {
      // 取出来数据的长度标识位
      int length = data[3];
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
          bleNotAllData[0] == kBLEDataFrameHeader) {
        int length = bleNotAllData[3];
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
    int id = element[2];
    switch (cmd){
      case ledControl:
        // 数码管显示
        CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
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
