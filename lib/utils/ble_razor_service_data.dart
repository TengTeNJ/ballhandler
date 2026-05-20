
import 'dart:async';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/razor_control_util.dart';

import '../constants/constants.dart';
import '../models/ble/ble_model.dart';
import 'ble_data_service.dart';
import 'ble_util.dart';
import 'game_data_bus.dart';
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
/*数码管数据上报（得分 + 倒计时）*/
const int scoreAndTimeResponse = 0x0b;
/*灯亮的标识位
* 0x00三路灯全灭
0x01亮，A路目标 00000001
0x02亮，B路目标 00000010
0x04亮，C路目标 00000100
0x05三路灯全亮   00000101
* */
const int lightFlagResponse = 0x0c;
/*状态*/
const int status = 0x0e;
/*形状变换状态上报*/
const int  shapeStatu= 0x0f;
/*游戏状态状态上报 0开始 1结束*/
const int  gameStatu= 0x10;
/*电机状态
* 正转 反转 停转
* */
enum BleRazorMotorStatu {stop,forward,reversal}

/// 档位上报对应的默认方向状态
/// value == 1: 默认反转（需要反转才能转到180初始形状）
/// value != 1: 默认正常（正转即可转到180初始形状）
class RazorGearState {
  static int rawValue = 0;
  static bool isDefaultReversed = false;

  static void update(int value) {
    rawValue = value;
    isDefaultReversed = value == 1;
  }
}

class RazorBleLogEntry {
  RazorBleLogEntry({
    required this.id,
    required this.time,
    required this.rawPacket,
    required this.rawHex,
    List<String>? parsedLogs,
  }) : parsedLogs = parsedLogs ?? <String>[];

  final int id;
  final DateTime time;
  final List<int> rawPacket;
  final String rawHex;
  final List<String> parsedLogs;
}

class RazorBleLogStore {
  RazorBleLogStore._();

  static const int _maxLogs = 300;
  static final List<RazorBleLogEntry> _logs = <RazorBleLogEntry>[];
  static int _idSeed = 1;
  static final StreamController<void> _changeController =
      StreamController<void>.broadcast();

  static List<RazorBleLogEntry> get logs => List<RazorBleLogEntry>.unmodifiable(_logs);
  static Stream<void> get changeStream => _changeController.stream;

  static int addRawPacket(List<int> packet) {
    final int id = _idSeed++;
    final entry = RazorBleLogEntry(
      id: id,
      time: DateTime.now(),
      rawPacket: List<int>.from(packet),
      rawHex: packet.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' '),
    );
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
    _changeController.add(null);
    return id;
  }

  static void addParsedLog(int? id, String log) {
    if (id == null) {
      return;
    }
    final index = _logs.indexWhere((e) => e.id == id);
    if (index < 0) {
      return;
    }
    _logs[index].parsedLogs.add(log);
    _changeController.add(null);
  }

  static void clear() {
    _logs.clear();
    _changeController.add(null);
  }
}

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
        final logId = RazorBleLogStore.addRawPacket(rightData);
        handleData(rightData, model, logId: logId); // 完整的一帧数据
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
          final logId = RazorBleLogStore.addRawPacket(rightData);
          handleData(rightData, model, logId: logId); // 完整的一帧数据
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

  static handleData(List<int> element, BLEModel mode, {int? logId}) {
    if (element.length < 4) {
      // print('解析数据出错');
      return;
    }
    // 去除帧头
    element = element.sublist(1, element.length);
    // 数据源地址
    int cmd = element[1];
    RazorBleLogStore.addParsedLog(logId, 'cmd=0x${cmd.toRadixString(16).padLeft(2, '0')}');
    // int id = element[2]; 暂且不需要重传机制 不需要id
    switch (cmd){
      case ledControl:
        // 数码管APP控制回复
        // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('数码管APP控制回复');
        RazorBleLogStore.addParsedLog(logId, '数码管APP控制回复');
        break;
      case lightControl:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('灯光APP控制回复');
        RazorBleLogStore.addParsedLog(logId, '灯光APP控制回复');
        break;
      case motorControl:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('电机APP控制回复');
        RazorBleLogStore.addParsedLog(logId, '电机APP控制回复');
        break;
      case powerOff:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
        print('关机APP控制回复');
        RazorBleLogStore.addParsedLog(logId, '关机APP控制回复');
        break;
      case appOnline:
      // 数码管APP控制回复
      // CommandSender().controller.sink.add(id);  // 通知控制类消息有相应
     //   print('上下线APP控制回复');
        break;
      case batteryLevelResponse:
      // 电量
        int value = element[2];
        print('电量=${value}');
        RazorBleLogStore.addParsedLog(logId, '电量上报=$value');
        BluetoothManager().gameData.powerValue = value;
        BleUtil.listenPowerValue(NavigatorUtil.utilContext, value);
        EventBus().sendEvent(kCurrentDeviceInfoChange);
        break;
      case heartBeatResponse:
      // 心跳上报
        int value = element[2];
        print('心跳上报=${value}');
        RazorBleLogStore.addParsedLog(logId, '心跳上报=$value');
        break;
      case hitResponse:
      // 击打上报 0b0000 0001（如bit1:1号，0无 1击打）
        List<int> datas = [1,2,4]; // 因为只有三个灯板 所以只有可能00000001 00000010 00000100 三种二进制的值 ，对应10进制分别为 1  2 4
        int value = element[2];
        String binaryString = value.toRadixString(2).padLeft(8, '0');
        print('击打上报=${binaryString}');
        print('击中了${datas.indexOf(value) + 1}号灯板');
        RazorBleLogStore.addParsedLog(
            logId, '击打上报=$binaryString, 击中灯板=${datas.indexOf(value) + 1}');
        break;
      case gearResponse:
      // 档位按下上报
        int value = element[2];
        RazorGearState.update(value);
        print('档位按下上报=${value}, 默认状态=${RazorGearState.isDefaultReversed ? '反转' : '正常'}');
        RazorBleLogStore.addParsedLog(
            logId, '档位上报=$value, 默认状态=${RazorGearState.isDefaultReversed ? '反转' : '正常'}');
        break;
      case motorFinishResponse:
      // 电机控制完成上报
        int value = element[2];
        print('电机控制完成上报=${value}');
        RazorBleLogStore.addParsedLog(logId, '电机控制完成上报=$value');
        EventBus().sendEvent(kReceiveControlResponse);
        break;
      case scoreAndTimeResponse:
      // 数码管数据上报（得分 + 倒计时）
        if (element.length > 3) {
          int score = element[3];
          int countdown = element[2];

          print('数码管上报 -> 得分=$score 倒计时=$countdown');
          RazorBleLogStore.addParsedLog(
              logId, '数码管上报: 得分=$score 倒计时=$countdown');
          BluetoothManager().gameData.score = score;

          // 👉 推送到你的数据层（这里建议你接入之前我给你的 GameDataBus）
          // 临时写法（你可以先这样用）
          // 👉 如果你有UI监听事件（建议加）
          // ✅ 用这个替换你之前的写法
          GameDataBus.instance.updateScoreAndTime(score, countdown);
          /*
          * UI层的用法
          * ValueListenableBuilder<int>(
  valueListenable: GameDataBus.instance.score,
  builder: (_, score, __) {
    return Text('得分: $score');
  },
)
          * */
          //EventBus().sendEvent('score_time_update');
        }
        break;
      case lightFlagResponse:
             // 亮灯标识
        int flag = element[2];
        int _lights = getLightStatus(flag);
        GameDataBus.instance.updateLights(_lights);
        print('亮灯=${_lights}');
        EventBus().sendEvent(kRazorLightRefresh);
        break;
      case shapeStatu:
      // 形状变换上报
        int value = element[2];
        print('形状变换上报=${value}');
        RazorBleLogStore.addParsedLog(logId, '形状变换上报=$value');
        EventBus().sendEvent(kRazorShapeRefresh);
        break;
      case gameStatu:
      // 形状变换上报
        int value = element[2];
        print('游戏状态上报=${value}');
        RazorBleLogStore.addParsedLog(logId, '游戏状态上报$value');
        BluetoothManager().gameData.gameStart = (value == 0x00);
        BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
        break;
      default:
        RazorBleLogStore.addParsedLog(logId, '未知cmd=$cmd');
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

int getLightStatus(int value) {
  if (value == 0) return 0;     // 全灭
  if (value == 5) return 4;     // 101 -> 全亮（1+2+3）

  // 判断是否只有一个bit是1
  // value & (value - 1) 的作用：把最低位的1“抹掉”
  // 如果抹掉后变成0 → 说明原来只有一个1
  // 否则 → 有多个1
  // 👉 value - 1 会把“最右边的1”变成0，并把后面的位全部变成1
  // 比如 110  -> 101
  if ((value & (value - 1)) == 0) {
    int index = 1;
    while (value > 1) {
      value = value >> 1;
      index++;
    }
    return index; // 返回 1 / 2 / 3
  }

  return -1; // 非法或多个灯亮（但不是全亮）
}
