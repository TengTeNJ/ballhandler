/*响应数据的CMD*/
import 'package:code/constants/constants.dart';
import 'package:code/models/global/game_data.dart';
import 'package:code/utils/blue_tooth_manager.dart';
import 'package:provider/provider.dart';

enum BLEDataType {
  none,
  dviceInfo,
  targetResponse,
  score,
  gameStatu,
  remainTime,
  millisecond,
}

class ResponseCMDType {
  static const int deviceInfo = 0x20; // 设备信息，包含开机状态、电量等
  static const int targetResponse = 0x26; // 标靶响应
  static const int score = 0x28; // 得分
  static const int gameStatu = 0x2A; // 游戏状态:开始和结束
  static const int remainTime = 0x2C; // 游戏剩余时长
  static const int millisecond = 0x32; // 游戏毫秒时间同步
}

/*蓝牙数据解析类*/
class BluetoothDataParse {
  // 数据解析
  static parseData(List<int> data) {
    if (data.contains(kBLEDataFrameHeader)) {
      List<List<int>> _datas = splitData(data);
      _datas.forEach((element) {
        if (element == null || element.length <= 3) {
          // 空数组
          // print('问题数据');
        } else {
          int cmd = element[1];
          switch (cmd) {
            case ResponseCMDType.deviceInfo:
              int parameter_data = element[2];
              int statu_data = element[3];
              if (parameter_data == 0x01) {
                // 开关机
                BluetoothManager().gameData.powerOn = (statu_data == 0x01);
              } else if (parameter_data == 0x02) {
                // 电量
                BluetoothManager().gameData.powerValue = statu_data;
              }
              break;
            case ResponseCMDType.targetResponse:
              int data = element[2];
              String binaryString = data.toRadixString(2); // 转换成二进制字符串
              if (binaryString != null && binaryString.length == 8) {
                // 前两位都是1，不区分红灯和蓝灯，截取后边6位，判断哪个灯在亮
                final sub_string = binaryString.substring(2, 7);
                final ligh_index = sub_string.indexOf('1');
                final actual_index = 5 - ligh_index + 1;
                BluetoothManager().gameData.currentTarget = actual_index;
                print('${actual_index}号灯亮了');
              }
              break;
            case ResponseCMDType.score:
              int data = element[2];
              BluetoothManager().gameData.score = data;
              // 通知
              print(
                  'BluetoothManager().dataChange=${BluetoothManager().dataChange}');
              BluetoothManager().triggerCallback(type: BLEDataType.score);
              print('${data}:得分');
              break;
            case ResponseCMDType.gameStatu:
              int data = element[2];
              BluetoothManager().gameData.gameStart = (data == 0x01);
              print('游戏状态---${data}');
              BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
              break;
            case ResponseCMDType.remainTime:
              int data = element[2];
              BluetoothManager().gameData.remainTime = data;
              print('游戏时长---${data}');
              BluetoothManager().triggerCallback(type: BLEDataType.remainTime);
              break;
            case ResponseCMDType.millisecond:
              int data = element[2];
              BluetoothManager().gameData.millSecond = data;
              print('毫秒刷新---${data}');
              BluetoothManager().triggerCallback(type: BLEDataType.millisecond);
              break;
          }
        }
      });
    } else {
      print('蓝牙设备响应数据不合法=${data}');
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
