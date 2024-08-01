import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/game_util.dart';
import 'package:code/utils/string_util.dart';

import '../constants/constants.dart';
import '../models/ble/ble_model.dart';

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
  static const int targetIn =
      0x64; // 目标击中 灯板ID(1BYTE,0-3)+灯掩码（1字节，使用BIT1-BIT0，取值：0b00-NA; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯）
  /*灯板状态字节定义：
  BIT7-BIT6:灯板3选灯掩码
  BIT5-BIT4:灯板2选灯掩码
  BIT3-BIT2:灯板1选灯掩码
  BIT1-BIT0:灯板0选灯掩码
  上面每个掩码占据2BITS，取值：0b00-关灯; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯。*/
  static const int statuSyn =
      0x66; // 状态同步 仅仅供子板向主板报告 所属灯板状态(1字节，按BIT分别表示)+电池电量（0-100，%）
  static const int newStatuSyn = 0x68; // 状态同步，供APP使用
}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;

/*蓝牙数据解析类*/
class BluetoothUltTimateDataParse {
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
          if (length != element.length) {
            // 说明不是完整数据
            bleNotAllData.addAll(element);
            if (bleNotAllData[0] - 1 == bleNotAllData.length) {
              print('组包1----${element}');
              handleData(bleNotAllData, model);
              isNew = true;
              bleNotAllData.clear();
            } else {
              isNew = false;
              Future.delayed(Duration(milliseconds: 10), () {
                if (!isNew) {
                  bleNotAllData.clear();
                }
              });
            }
          } else {
            handleData(element, model);
          }
        }
      });
    } else {
      bleNotAllData.addAll(data);
      // 减去3是因为去掉了一个枕头 和 bleNotAllData[2]的值不计算数据源设备地址和数据目的设备地址
      if (bleNotAllData.length >= 3 &&
          (bleNotAllData[2] - 3) == bleNotAllData.length) {
        handleData(bleNotAllData, model);
        isNew = true;
        bleNotAllData.clear();
      } else {
        isNew = false;
        Future.delayed(Duration(milliseconds: 10), () {
          if (!isNew) {
            bleNotAllData.clear();
          }
        });
      }
      print('蓝牙设备响应数据不包含帧头或者数据被分包=${data}');
    }
  }

  static handleData(List<int> element, BLEModel mode) {
    if (element.length < 4) {
      print('解析数据出错');
      return;
    }
    // 数据源地址
    int source = element[1];
    String binaryString = source.toRadixString(2);
    String boardString = binaryString.substring(2, binaryString.length);
    // 灯板索引 0-5
    int targetIndex = (boardString.indexOf('1') - 5).abs();
    // 数据赋值
    BluetoothManager().gameData.currentTarget = targetIndex;
    // 目的地址
    int destination = element[2];
    String destinationBinaryString = destination.toRadixString(2);
    String destinationBit7 = destinationBinaryString.substring(0, 1);
    if (destinationBit7 == '1') {
      // 代表数据是发送给app的
      int cmd = element[3];
      switch (cmd) {
        case ResponseCMDType.targetIn:
          int data1 = element[4]; // 灯板ID(1BYTE,0-3)
          int data2 = element[
              5]; // 灯掩码（1字节，使用BIT1-BIT0，取值：0b00-NA; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯）
          String binaryString = data2.toRadixString(2);
          String temp = '';
          switch (binaryString) {
            case '0':
              // 关闭
              temp = '关闭';
              break;
            case '1':
              // 红灯
              temp = '红灯';
              break;
            case '10':
              //  蓝灯
              temp = '蓝灯';
              break;
            case '11':
              // 红+蓝灯
              temp = '红灯+蓝灯';
              break;
          }
          print('击中了${targetIndex}号控制板的${data1}号灯板,状态为${temp}');
          break;
        case ResponseCMDType.statuSyn:
          // 状态同步
          int data1 = element[4]; // 所属灯板状态(1字节，按BIT分别表示)+电池电量（0-100，%）
          /*
          * BIT7-BIT6:灯板3选灯掩码
            BIT5-BIT4:灯板2选灯掩码
            BIT3-BIT2:灯板1选灯掩码
            BIT1-BIT0:灯板0选灯掩码
           上面每个掩码占据2BITS，取值：0b00-关灯; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯。
          * */
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
          print(
              '${targetIndex}号控制板有状态更新，所对应的4个灯的状态为3号:${board3} 2号:${board2} 1号:${board3} 0号:${board0}');
          BluetoothManager()
              .triggerCallback(type: BLEDataType.statuSynchronize);
          break;
        case ResponseCMDType.newStatuSyn:
          // 新状态同步(APP用)
          // 主板MASTER向上状态同步，主要用于MASTER向APP同步
          // 所有板的在线状态(1字节)+所有板的LED状态(6字节)+所有板的电池状态(6字节)+游戏状态(1字节)+游戏模式(1字节)+倒计时(2字节)+分值(2字节)
          // 在线标志与协议结构中的发送设备编码一样，BIT0表示MASTER，BIT1表示SLAVE1，以此类推；bit值为1表示设备在线；
          // 每个板的LED状态使用1个字节，按照BIT0-BIT1表示灯板0，BIT1-BIT2表示灯板1，以此类推；
          // 每个板的电池状态占据1字节，为百分比，如90表示90%；
          // 游戏状态占据1字节：0x00-不在游戏状态，0x01-游戏状态
          // 游戏模式占据1字节：0x01-P1模式，0x02-P2模式，0x03-P3模式；
          // 倒计时占据2字节：以秒为单位的倒计时；
          // 分值占据2字节：
          // 在线状态
          int onLineStatu = element[4]; // 在线状态 0x01 在线
          //  解析灯的状态
          parseAllLedStatu(element);
          // 所有板子的电池的电量 为百分比，如90表示90%
          int battery0 = element[16];
          int battery1 = element[15];
          int battery2 = element[14];
          int battery3 = element[13];
          int battery4 = element[12];
          int battery5 = element[11];
          BluetoothManager().gameData.p3DeviceBatteryValues.clear();
          BluetoothManager().gameData.p3DeviceBatteryValues.addAll(
              [battery0, battery1, battery2, battery3, battery4, battery5]);
          //  游戏状态
          int gameStatu = element[17]; // 0x00-不在游戏状态，0x01-游戏状态
          BluetoothManager().gameData.ultimateIsGaming = gameStatu == 1;

          // 游戏时长倒计时
          int remainTime = element[19]; // 游戏时长倒计时
          BluetoothManager().gameData.remainTime = remainTime;
          // 游戏得分
          int score = element[20]; // 游戏时长倒计时
          BluetoothManager().gameData.score = score;
          // 设备状态信息变化 通知刷新页面
          BluetoothManager()
              .triggerCallback(type: BLEDataType.statuSynchronize);
      }
    } else {
      // 代表数据发送方不符合条件 APP端忽略
      print('代表数据发送方不符合条件 APP端忽略');
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
