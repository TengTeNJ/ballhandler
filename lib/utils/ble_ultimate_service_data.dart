import 'package:code/models/game/hit_target_model.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:code/utils/game_util.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/string_util.dart';
import 'package:get_it/get_it.dart';

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
  static const int onLine = 0x00; // 在线状态(1字节)在线标志与协议结构中的设备地址编码一样，BIT0表示Central，BIT1表示Slave1，以此类推；bit值为1表示设备在线；
  static const int allBoardStatu = 0x6A; // 所有灯板的状态 CENTRAL(中心主机)向APP同步所有灯板数据及状态。所有板的LED状态(6字节)+所有板的电池状态(6字节)
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
          if(element.length <= 2){
            bleNotAllData.addAll(data);
            return;
          }
          int length = element[2] - 1; // 获取长度 去掉了枕头
          if (length != element.length) {
            // 说明不是完整数据
            bleNotAllData.addAll(element);
            if (bleNotAllData[2] - 1 == bleNotAllData.length) {
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
          (bleNotAllData[2] - 1) == bleNotAllData.length) {
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
     //  print('蓝牙设备响应数据不包含帧头或者数据被分包=${data}');
    }
  }


  static handleData(List<int> element, BLEModel mode) {
    if (element.length < 4) {
      // print('解析数据出错');
      return;
    }
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
    // 数据源赋值
    BluetoothManager().gameData.currentTarget = targetIndex;
    // 目的地址
    int destination = element[1];
    String destinationString =
        StringUtil.decimalToBinary(destination).padLeft(8, '0');
    //print('目的地址=${StringUtil.decimalToBinary(destination)}');
    if (destinationString.substring(0, 1) == '1') {
      // 代表数据是发送给app的
      int cmd = element[3];
      switch (cmd) {
        case ResponseCMDType.onLine:
          // 在线状态 一个字节 8位BIT 0表示Central，BIT1表示Slave1，以此类推；bit值为1表示设备在线；
          int data = element[4];
          String binaryString = data.toRadixString(2).padLeft(8, '0');
          for(int i =0 ; i < 6; i ++){
            print('${i}号在线状态:${binaryString.substring(binaryString.length - (i+1),binaryString.length-i)}');
          }
          break;
        case ResponseCMDType.targetIn:
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if(gameUtil.modelId != 3){
            // 只有P3模式才处理击中
            break;
          }
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
          HitTargetModel model =  HitTargetModel(boardIndex: targetIndex, ledIndex: data1, statu:  StringUtil.lightToStatu(binaryString.padLeft(2,'0')));
          BluetoothManager().gameData.hitTargetModel = model;
          print('击中了${targetIndex}号控制板的${data1}号灯板,状态为${temp}');
          BluetoothManager()
              .p3TriggerCallback(type: BLEDataType.targetIn);
          break;
        case ResponseCMDType.allBoardStatu:
          // 初始时 所有灯板的状态 CENTRAL(中心主机)向APP同步所有灯板数据及状态。
         // 所有板的LED状态(6字节)+所有板的电池状态(6字节)
        // 4到9是LED状态，每个LED板子一个字节，每个面板上有四个灯板，每个灯板占两个位 0b00-关灯; 0b01-红灯; 0b10-蓝灯; 0b11-红灯+蓝灯。
        // 灯板状态
        for(int i =0; i < 6; i++){
          // 取出数据位，并转换成2进制字符串
          int data = element[4+i];
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
        for(int i =0; i < 6; i++){
          // 取出数据位，并转换成2进制字符串
          int battery = element[10+i];
          BluetoothManager().gameData.p3DeviceBatteryValues[targetIndex] =
              battery;
        }
          break;
        case ResponseCMDType.statuSyn:
      //    print("deviceName  上报来的数据data = ${element.map((toElement)=>toElement.toRadixString(16)).toList()}");
          // 上报原因：0x01：灯板状态；0x02：电量状态；0x03：灯板+电量状态；
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
            // print(
            //     '${targetIndex}号控制板有状态更新，所对应的4个灯的状态为3号:${board3} 2号:${board2} 1号:${board3} 0号:${board0}');
          } else if (data1 == 2) {
            // 电量状态；0, 5, 25, 50, 75, 100
            int battery = element[6];
            BluetoothManager().gameData.p3DeviceBatteryValues[targetIndex] =
                battery;
            print('${targetIndex}号灯的电量变化，电量值为${battery}');
          } else if (data1 == 3) {
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
            // print(
            //     '${targetIndex}号控制板有状态更新，所对应的4个灯的状态为3号:${board3} 2号:${board2} 1号:${board3} 0号:${board0}');
            int battery = element[6];
            BluetoothManager().gameData.p3DeviceBatteryValues[targetIndex] =
                battery;
            print('${targetIndex}号灯的电量变化，电量值为${battery}');
          }
          BluetoothManager()
              .triggerCallback(type: BLEDataType.statuSynchronize);
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
                BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
                break;
              }
            case 2:
              {
                // 模式选择变化 0x01-P1模式，0x02-P2模式，0x03-P3模式；
                int mode = element[6];
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
               // print('倒计时变化=${remain_time}');
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
                print('得分=${balls_count}'
                );
                BluetoothManager().gameData.score = balls_count;
                break;
              }
            case 0x0f:
              {
                int statu = element[5];
                print('游戏状态变化=${statu}');
                // 模式选择变化 0x01-P1模式，0x02-P2模式，0x03-P3模式；
                int mode = element[6];
                print('游戏选择变化=${mode}');
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
                print('得分=${score}');
                BluetoothManager().gameData.score = score;
                BluetoothManager()
                    .triggerCallback(type: BLEDataType.scoreAndRemainTime);
              }
          }
          break;
      }
    } else {
      // 代表数据发送方不符合条件 APP端忽略
      print('数据目的发送方不符合条件 APP端忽略:${destinationString}');
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
