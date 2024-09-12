import 'dart:async';
import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/control_time_out_util.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/utils/toast.dart';
import 'package:get_it/get_it.dart';
import '../constants/constants.dart';
import '../models/ble/ble_model.dart';
import 'ble_util.dart';
import 'navigator_util.dart';
import 'notification_bloc.dart';

// 270六块板子，1快主板，5块从板。每个板子有4个灯，成为灯板3、2、1、0
/**
 * Start ( 1 Byte)
    0xA5	数据源设备地址（1Byte）	数据目的设备地址（1Byte）	Length (1 Byte)
    = Start + Length + CMD + Data + CS + End	CMD(1 Byte)
    Command	Data(n Bytes)	CS(1 Byte)
    Checksum	End(1 Byte)
    0xAA
 *
 */

enum BleULTimateLighStatu { close, red, blue, redAndBlue }

class ResponseCMDType {
  /*灯板状态字节定义：
  BIT7-BIT6:灯板3选灯掩码
  BIT5-BIT4:灯板2选灯掩码
  BIT3-BIT2:灯板1选灯掩码
  BIT1-BIT0:灯板0选灯掩码
  上面每个掩码占据2BITS，取值：0b00-关灯; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯。*/
  static const int targetIn =
      0x64; // 目标击中 灯板ID(1BYTE,0-3)+灯掩码（1字节，使用BIT1-BIT0，取值：0b00-NA; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯）
  /*上报原因（1字节）+数据（2字节，根据上报原因为：所属灯板状态(1字节，按BIT分别表示)+电池电量（0-100，%）
  上报原因：
  0x01：灯板状态；
  0x02：电量状态；
  0x03：灯板+电量状态；
  灯板状态字节定义：
  BIT7-BIT6:灯板3选灯掩码
  BIT5-BIT4:灯板2选灯掩码
  BIT3-BIT2:灯板1选灯掩码
  BIT1-BIT0:灯板0选灯掩码
  上面每个掩码占据2BITS，取值：0b00-关灯; 0b01-红灯; 0b10-蓝灯;0b11-红灯+蓝灯。*/
  static const int statuSyn = 0x66;
  static const int ledControlStatu =
      0x61; // 灯板LED控制返回； 返回字（1字节）：0x00/失败；0x01/成功

  /*主板MASTER向上状态同步，主要用于MASTER向APP同步
上报原因（1字节）+所有板的在线状态(1字节) +游戏状态(1字节)+游戏模式(1字节)+倒计时(2字节)+分值(2字节)

上报原因：
0x01: 游戏状态变化；
0x02: 模式选择变化；
0x04: 倒计时变化；
0x08: 得分变化；

每个板的LED状态使用1个字节，按照BIT0-BIT1表示灯板0，BIT1-BIT2表示灯板1，以此类推；
游戏状态占据1字节：0x00-IDLE(选择模式状态)；0x01-游戏预备；0x02-游戏开始；0x03-游戏结束。
游戏模式占据1字节：0x01-P1模式，0x02-P2模式，0x03-P3模式；
倒计时占据2字节：以秒为单位的倒计时；
分值占据2字节：
  * */
  static const int newStatuSyn = 0x68; // 上报游戏状态数据更新数据
  static const int heartBeat = 0x30; // 心跳查询
  static const int onLine =
      0x00; // 在线状态(1字节)在线标志与协议结构中的设备地址编码一样，BIT0表示Central，BIT1表示Slave1，以此类推；bit值为1表示设备在线；
  static const int allBoardStatu =
      0x6A; // 所有灯板的状态 CENTRAL(中心主机)向APP同步所有灯板数据及状态。所有板的LED状态(6字节)+所有板的电池状态(6字节)
  static const int masterStatu =
      0x12; // Central主机当前的系统状态：1字节0: 系统初始化；1: 系统配网；2: 系统游戏；3: 系统设置；4: 系统管理
  static const int queryMasterStatuResponse =
      0x15; // APP查询中心主机当前系统状态的返回 字节1：0x01（成功），字节2：当前中心主机的系统状态，状态值定义同0x12命令；
}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
Timer? delayTimer;

/*蓝牙数据解析类*/
class BluetoothUltTimateDataParse {
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
    //print('handleNotFullData1${data.map((toElement) => toElement.toRadixString(16)).toList()}');
    //print('handleNotFullData12 ${isNew}');
    if (isNew) {
      isNew = false;
      delayTimer = Timer(Duration(milliseconds: 150), () {
        if (!isNew) {
          print('解析数据超时 ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
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
    int source = element[0];
    if (source == 0x80) {
      // 数据源不能是APP
      return;
    }
    String binaryString = source.toRadixString(2).padLeft(8, '0');
    String boardString = binaryString.substring(2, binaryString.length);
    // 灯板索引 0-5
    int targetIndex = (boardString.indexOf('1') - 5).abs();
    // 目的地址
    int destination = element[1];
    String destinationString =
        StringUtil.decimalToBinary(destination).padLeft(8, '0');
    if (destinationString.substring(0, 1) == '1') {
      // 代表数据是发送给app的
      int cmd = element[3];
      switch (cmd) {
        case ResponseCMDType.heartBeat:
          // 心跳查询，直接回复心跳响应
          BluetoothManager().writerDataToDevice(mode, responseHearBeat());
          break;
        case ResponseCMDType.ledControlStatu:
          int data = element[4];
          // int controlBoard = element[0];
          print(
              "控制返回的data = ${element.map((toElement) => toElement.toRadixString(16)).toList()}");
          if (ControlTimeOutUtil().controlLedId != data) {
            print('灯板不对应');
            return;
          }
          print('控制成功data=${data}');
          if (ControlTimeOutUtil().timeOutTimer != null) {
            ControlTimeOutUtil().timeOutTimer!.cancel();
            ControlTimeOutUtil().timeOutTimer = null;
          }
          ControlTimeOutUtil().controlLedId ++;
          ControlTimeOutUtil().completer.complete(true);
          ControlTimeOutUtil().reset();
          break;
        case ResponseCMDType.masterStatu:
          // Central主机当前的系统状态：1字节0: 系统初始化；1: 系统配网；2: 系统游戏；3: 系统设置；4: 系统管理
          int data = element[4];
          // print('Central主机当前的系统状态=${data}');
          BluetoothManager().gameData.masterStatu = data;
          BluetoothManager().triggerCallback(type: BLEDataType.masterStatu);
          break;
        case ResponseCMDType.queryMasterStatuResponse:
          //   字节1：0x01（成功），字节2：当前中心主机的系统状态，状态值定义同0x12命令； Central主机当前的系统状态：1字节0: 系统初始化；1: 系统配网；2: 系统游戏；3: 系统设置；4: 系统管理
          int data1 = element[4];
          int data2 = element[5];
          //print('APP查询中心主机当前系统状态的返回结果=${data1}');
          if (data1 == 1) {
            // 成功
            //print('查询Central主机当前的系统状态的返回=${data2}');
            BluetoothManager().gameData.masterStatu = data2;
            BluetoothManager().triggerCallback(type: BLEDataType.masterStatu);
          }
          break;
        case ResponseCMDType.onLine:
          // 在线状态 一个字节 8位BIT 0表示Central，BIT1表示Slave1，以此类推；bit值为1表示设备在线；
          int data = element[4];
          String binaryString = data.toRadixString(2).padLeft(8, '0');
          for (int i = 0; i < 6; i++) {
            String onLineStatu = binaryString.substring(
                binaryString.length - 1 - i, binaryString.length - i);
            // 在线状态赋值
            int statu = int.parse(onLineStatu);
            BluetoothManager().gameData.p3DeviceOnlineStatus[i] = statu;
            String v = binaryString.substring(
                binaryString.length - (i + 1), binaryString.length - i);
            if (v == '0') {
              TTToast.showErrorInfo('Board ${kP3DataAndProductIndexMap[i]} offline');
            }
          }
          BluetoothManager().triggerCallback(type: BLEDataType.onLine);
          break;
        case ResponseCMDType.targetIn:
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if (gameUtil.modelId != 3) {
            // 只有P3模式才处理击中
            break;
          }
          int data1 = element[4]; // 灯板ID(1BYTE,0-3)
          int data2 = element[
              5]; // 灯掩码（1字节，使用BIT1-BIT0，取值：0b00-NA; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯）
          String binaryString = data2.toRadixString(2);
          // 数据源赋值
          BluetoothManager().gameData.currentTarget = targetIndex;
          HitTargetModel model = HitTargetModel(
              boardIndex: targetIndex,
              ledIndex: data1,
              statu: StringUtil.lightToStatu(binaryString.padLeft(2, '0')));
          BluetoothManager().gameData.hitTargetModel = model;
          // print(
          //     '击中了${targetIndex}号控制板的${data1}号灯板,状态为${StringUtil.lightToStatu(binaryString)}');
          BluetoothManager().p3TriggerCallback(type: BLEDataType.targetIn);
          break;
        case ResponseCMDType.allBoardStatu:
          // 初始时 所有灯板的状态 CENTRAL(中心主机)向APP同步所有灯板数据及状态。
          // 所有板的LED状态(6字节)+所有板的电池状态(6字节)
          // 4到9是LED状态，每个LED板子一个字节，每个面板上有四个灯板，每个灯板占两个位 0b00-关灯; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯。
          // 灯板状态
          for (int i = 0; i < 6; i++) {
            // 取出数据位，并转换成2进制字符串
            int data = element[4 + i];
            String binaryString = data.toRadixString(2).padLeft(8, '0');
            // 数组的索引的高低 对应 灯板的编号的高低
            BluetoothManager().gameData.currentTarget = i;
            String board3 = binaryString.substring(0, 2); // 灯板3的状态
            String board2 = binaryString.substring(2, 4); // 灯板2的状态
            String board1 = binaryString.substring(4, 6); // 灯板1的状态
            String board0 = binaryString.substring(6, 8); // 灯板0的状态
            BluetoothManager().gameData.lightStatus = [
              StringUtil.lightToStatu(board0),
              StringUtil.lightToStatu(board1),
              StringUtil.lightToStatu(board2),
              StringUtil.lightToStatu(board3)
            ];
            BluetoothManager()
                .triggerCallback(type: BLEDataType.allBoardStatuOneByOne);
          }
          BluetoothManager()
              .triggerCallback(type: BLEDataType.allBoadrStatuFinish);
          // 电池电量
          for (int i = 0; i < 6; i++) {
            // 取出数据位，并转换成2进制字符串
            int battery = element[10 + i];
            BluetoothManager().gameData.p3DeviceBatteryValues[i] = battery;
          }
          GameUtil gameUtil = GetIt.instance<GameUtil>();
            List<int> _batteryValues =
                BluetoothManager().gameData.p3DeviceBatteryValues;
            int minValue = _batteryValues.reduce((a, b) => a < b ? a : b);
            gameUtil.selectedDeviceModel.powerValue = minValue;
            // 监听电量
            BleUtil.listenPowerValue(NavigatorUtil.utilContext, minValue);
            EventBus().sendEvent(kCurrent270DeviceInfoChange);
          break;
        case ResponseCMDType.statuSyn:
          //    print("deviceName  上报来的数据data = ${element.map((toElement)=>toElement.toRadixString(16)).toList()}");
          // 上报原因：0x01：灯板状态；0x02：电量状态；0x03：灯板+电量状态；
          BluetoothManager().gameData.currentTarget = targetIndex;
          int data1 = element[4]; // 所属灯板状态(1字节，按BIT分别表示)+电池电量（0-100，%）
          if (data1 == 1) {
            // 灯板状态
            int data2 = element[5]; // 灯板状态字节
            String binaryString = data2.toRadixString(2).padLeft(8, '0');
            String board3 = binaryString.substring(0, 2); // 灯板3的状态
            String board2 = binaryString.substring(2, 4); // 灯板2的状态
            String board1 = binaryString.substring(4, 6); // 灯板1的状态
            String board0 = binaryString.substring(6, 8); // 灯板0的状态
            BluetoothManager().gameData.lightStatus = [
              StringUtil.lightToStatu(board0),
              StringUtil.lightToStatu(board1),
              StringUtil.lightToStatu(board2),
              StringUtil.lightToStatu(board3)
            ];
            BluetoothManager()
                .triggerCallback(type: BLEDataType.statuSynchronize);
            // print(
            //     '${targetIndex}灯板状态变化++++:${binaryString}-----${BluetoothManager().gameData.lightStatus}');
          } else if (data1 == 2) {
            // 电量状态；0, 5, 25, 50, 75, 100
            int battery = element[6];
            BluetoothManager().gameData.p3DeviceBatteryValues[targetIndex] =
                battery;
            // print('${targetIndex}号灯的电量变化，电量值为${battery}');
            GameUtil gameUtil = GetIt.instance<GameUtil>();
              List<int> _batteryValues =
                  BluetoothManager().gameData.p3DeviceBatteryValues;
              int minValue = _batteryValues.reduce((a, b) => a < b ? a : b);
              gameUtil.selectedDeviceModel.powerValue = minValue;
              // 监听电量
              BleUtil.listenPowerValue(NavigatorUtil.utilContext, minValue);
              EventBus().sendEvent(kCurrent270DeviceInfoChange);
          } else if (data1 == 3) {
            GameUtil gameUtil = GetIt.instance<GameUtil>();
            // 灯板 + 电量
            int data2 = element[5]; // 灯板状态字节
            String binaryString = data2.toRadixString(2).padLeft(8, '0');
            String board3 = binaryString.substring(0, 2); // 灯板3的状态
            String board2 = binaryString.substring(2, 4); // 灯板2的状态
            String board1 = binaryString.substring(4, 6); // 灯板1的状态
            String board0 = binaryString.substring(6, 8); // 灯板0的状态
            BluetoothManager().gameData.lightStatus = [
              StringUtil.lightToStatu(board0),
              StringUtil.lightToStatu(board1),
              StringUtil.lightToStatu(board2),
              StringUtil.lightToStatu(board3)
            ];

            BluetoothManager()
                .triggerCallback(type: BLEDataType.statuSynchronize);
            // print(
            //     '${targetIndex}号控制板有状态更新，所对应的4个灯的状态为3号:${board3} 2号:${board2} 1号:${board3} 0号:${board0}');
            int battery = element[6];
            BluetoothManager().gameData.p3DeviceBatteryValues[targetIndex] =
                battery;
              List<int> _batteryValues =
                  BluetoothManager().gameData.p3DeviceBatteryValues;
              int minValue = _batteryValues.reduce((a, b) => a < b ? a : b);
              gameUtil.selectedDeviceModel.powerValue = minValue;
              // 监听电量
              BleUtil.listenPowerValue(NavigatorUtil.utilContext, minValue);
              EventBus().sendEvent(kCurrent270DeviceInfoChange);
          }
          break;
        case ResponseCMDType.newStatuSyn:
          int reason = element[
              4]; // 上报原因：0x01: 游戏状态变化；0x02: 模式选择变化；0x04: 倒计时变化；0x08: 得分变化；
          switch (reason) {
            case 1:
              {
                // 游戏状态变化 0x00-IDLE(选择模式状态) 0x01-游戏预备；0x02-游戏开始；0x03-游戏结束。
                int statu = element[5];
                BluetoothManager().gameData.utimateGameSatatu = statu;
                print('----------------utimateGameSatatu----------------');
                BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
                break;
              }
            case 2:
              {
                // 模式选择变化 0x00-P1模式，0x01-P2模式，0x02-P3模式；
                int modeStatu = element[6];
                GameUtil gameUtil = GetIt.instance<GameUtil>();
                // 主动切换模式时 如果app已经进入到了选择模式后的步骤 则进行手动切换
                if (gameUtil.selectedDeviceModel.device != null &&
                    gameUtil.selectedDeviceModel.device!.id ==
                        mode.device!.id) {
                  gameUtil.modelId = modeStatu + 1;
                }
                break;
              }
            case 4:
              {
                // 倒计时变化 两个字节
                int count_data1 = element[7];
                int count_data2 = element[8];
                String count1String = StringUtil.decimalToBinary(count_data1);
                String count2String = StringUtil.decimalToBinary(count_data2);
                String valueString = count1String + count2String;
                int remain_time = StringUtil.binaryStringToDecimal(valueString);
                BluetoothManager().gameData.remainTime = remain_time;
                BluetoothManager()
                    .triggerCallback(type: BLEDataType.remainTime);
                break;
              }
            case 8:
              {
                // 得分态变化
                int count_data1 = element[9];
                int count_data2 = element[10];
                String count1String = StringUtil.decimalToBinary(count_data1);
                String count2String = StringUtil.decimalToBinary(count_data2);
                String valueString = count1String + count2String;
                int balls_count = StringUtil.binaryStringToDecimal(valueString);
                BluetoothManager().gameData.score = balls_count;
                break;
              }
            case 0x0f:
              {
                int statu = element[5];
                BluetoothManager().gameData.utimateGameSatatu = statu;
                // 模式选择变化 0x01-P1模式，0x02-P2模式，0x03-P3模式；
                int mode = element[6];
                // 倒计时变化 两个字节
                int count_data1 = element[7];
                int count_data2 = element[8];
                String count1String = StringUtil.decimalToBinary(count_data1);
                String count2String = StringUtil.decimalToBinary(count_data2);
                String valueString = count1String + count2String;
                int remain_time = StringUtil.binaryStringToDecimal(valueString);
                // print('倒计时变化=${remain_time}');
                BluetoothManager().gameData.remainTime = remain_time;
                // 得分态变化
                int score_data1 = element[9];
                int score_data2 = element[10];
                String score1String = StringUtil.decimalToBinary(score_data1);
                String score2String = StringUtil.decimalToBinary(score_data2);
                String scoreValueString = score1String + score2String;
                int score = StringUtil.binaryStringToDecimal(scoreValueString);
                BluetoothManager().gameData.score = score;
                BluetoothManager()
                    .triggerCallback(type: BLEDataType.scoreAndRemainTime);
              }
          }
          break;
      }
    } else {
      // 代表数据发送方不符合条件 APP端忽略
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
