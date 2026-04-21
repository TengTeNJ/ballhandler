import 'package:code/utils/ble_razor_service_data.dart';
import 'package:code/utils/string_util.dart';
import '../constants/constants.dart';
/*数码管显示*/
List<int> ledControlData(int left,int right){
  print('数码管显示---');
  int start = kBLEDataFrameRazorHeader;
 // int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int data1 = left;
  int data2 = right;
  int cs = (start + 0x07 + ledControl + data1 + data2 + end) & 0xff;
  List<int> values = [start,0x07,ledControl,data1,data2,cs,end];
   print('数码管：${values.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}');
  return values;
}
/*灯光控制
*0x01,0x02，0x04，0x05（1:1号，2:2号，4:3号，5：全亮，其余全灭）
* 00000001 1号 对应数据[0,0,1] 传感器对着时 正放时下面的，传感器不对着时 正放时上面的
* 00000010 2号 对应数据[0,0,1]
* 00000100 3号 对应数据[0,0,1]
* 00000101 全灭 对应数据[1,0,1]  (虽然按照规律全灭用00000000 更合适，但是协议统一(固件端已经写好了) 也可以)
* 测试只能一个个灯光控制开，超过1个1就会失效
* 、*/
List<int> lightsControlData(List<int> lightStatus){
  print('灯光控制---');
  int value = 0;
  for (int i = 0; i < lightStatus.length; i++) {
    if (lightStatus[i] == 1) {
      value |= (1 << i); // 左移 + 按位或
    }
  }
  int lightStatuData = value;
  int start = kBLEDataFrameRazorHeader;
 // int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = (start + 0x07 + lightControl + lightStatuData  + end) & 0xff;
  List<int> values = [start,0x07,lightControl,lightStatuData,cs,end];
  return values;
}

/*关机控制*/
List<int> powerOffControlData({int value = 0x01}){
  print('关机---value');
  int start = kBLEDataFrameRazorHeader;
  // int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x06 + powerOff + value  + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x06,powerOff,value,cs,end];
  return values;
}

/*APP上下线控制
*上线（0x01）下线（0x00）
* */
List<int> appOnLineControlData({int value = 0x01}){
  print('APP上下线---value');
  int start = kBLEDataFrameRazorHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x06 + appOnline + value  + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x06,appOnline,value,cs,end];
  return values;
}

/*电机控制*/
List<int> motorControlData({List<BleRazorMotorStatu> motorStatus = const [BleRazorMotorStatu.stop,BleRazorMotorStatu.stop],List<int>timers = const [0,0]}){
  print('电机控制---value');
  int start = kBLEDataFrameRazorHeader;
 // int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x09 + motorControl + motorStatus[0].index + timers[0]  + motorStatus[1].index + timers[1] + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x09,motorControl,motorStatus[0].index,timers[0],motorStatus[1].index,timers[1],cs,end];
  print('values == ${values}');
  return values;
}

