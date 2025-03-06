import 'package:code/utils/ble_razor_service_data.dart';
import 'package:code/utils/string_util.dart';
import '../constants/constants.dart';
/*数码管显示*/
List<int> ledControlData(int value){
  print('数码管显示---value');
  String score = value.toString().padLeft(2, '0');
  int start = kBLEDataFrameHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int data1 = 0x30 + int.parse(score.substring(0, 1));
  int data2 = 0x30 + int.parse(score.substring(1, 2));
  int cs = start + 0x08 + ledControl + id + data1 + data2 + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x08,ledControl,id,data1,data2,cs,end];
  return values;
}
/*灯光控制*/
List<int> lightsControlData(List<int> lightStatus){
  print('灯光控制---value');
  String lightStatuString = '00000';
  lightStatus.forEach((element){
    lightStatuString = lightStatuString + element.toString();
  });
  int lightStatuData = StringUtil.binaryStringToDecimal(lightStatuString);
  int start = kBLEDataFrameHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x07 + lightControl + id + lightStatuData  + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x07,lightControl,id,lightStatuData,cs,end];
  return values;
}

/*关机控制*/
List<int> powerOffControlData({int value = 0x01}){
  print('关机---value');
  int start = kBLEDataFrameHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x07 + powerOff + id + value  + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x07,powerOff,id,value,cs,end];
  return values;
}

/*APP上下线控制
*上线（0x01）下线（0x00）
* */
List<int> appOnLineControlData({int value = 0x01}){
  print('APP上下线---value');
  int start = kBLEDataFrameHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x07 + appOnline + id + value  + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x07,appOnline,id,value,cs,end];
  return values;
}

/*电机控制*/
List<int> motorControlData({List<BleRazorMotorStatu> motorStatus = const [BleRazorMotorStatu.stop,BleRazorMotorStatu.stop],List<int>timers = const [0,0]}){
  print('电机控制---value');
  int start = kBLEDataFrameHeader;
  int id = 100; // 每条消息的控制id 先默认100
  int end = kBLEDataFramerFoot;
  int cs = start + 0x0a + motorControl + id + motorStatus[0].index + timers[0]  + motorStatus[1].index + timers[1] + end;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString = binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> values = [start,0x0a,motorControl,id,motorStatus[0].index,timers[0],motorStatus[1].index,timers[1],cs,end];
  return values;
}

