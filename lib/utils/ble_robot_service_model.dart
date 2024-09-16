import 'dart:async';
import 'package:code/utils/ble_robot_data.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/notification_bloc.dart';

import '../constants/constants.dart';
import '../models/ble/ble_model.dart';

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
Timer? delayTimer;

/*蓝牙数据解析类*/
class BluetoothRobotDataParse {
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
    if (element.length <= 4) {
      return;
    }
    int cmd = element[1];
    if (cmd == 0x72) {
      // 机器人就需状态
      int statu = element[2];
      if (statu != BluetoothManager().robotStatu) {
        BluetoothManager().robotStatu = statu;
        EventBus().sendEvent(kRobotStatuChange);
      }

      if (statu == 1) {
        // 空闲
      } else {
        // 运行
      }
    }else if(cmd == 0x71){
      // 到达指定灯位
      int index = element[2];
      BluetoothManager().robotIndex = index;
      BluetoothManager().hitModel.addListener((){
       BluetoothManager().writerDataToDevice(BluetoothManager().robotModel, noticeRobotIndex( BluetoothManager().hitModel.value));
      });
      Future.delayed(Duration(milliseconds: 200),(){
        BluetoothManager().hitModel.removeListener((){});
      });
    }
  }
}
