import 'package:code/utils/string_util.dart';
import '../constants/constants.dart';

const kPowerOff = 0x01; // 关机
const kReboot = 0x02; // REBOOT 重新启动
const kResetAutoOffTimer = 0x03; // 重置自动关机定时器
const kChannel = 0x04; // 通信通道
const kReferenceLevel = 0x05; // 干扰容错级别
const kAutoOffDuration = 0x06; // 自动关机时间
const kDebugSwitch = 0x07; // DEBUG开关
const kFactoryReset = 0x08; // 恢复出厂设置
const kBTAuto = 11; // BT自动断连开关
const k321Pre = 12; // 321预备开关
const kLongPressCheck =
    13; // 长按检测功能选择；数据1字节：0x00: 关闭；0x01: 打开工厂模式；0x02: 打开用户模式；缺省：0x01。
const kBLTMacAdress = 14; // 蓝牙MAC地址
const kBLTName = 15; // 蓝牙名称
const kBLTReset = 16; // 重置蓝牙模块
/*查询通信通道*/
List<int> queryChannel() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kChannel;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询干扰容错级别*/
List<int> queryReferenceLevel() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kReferenceLevel;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询自动关机时间*/
List<int> queryOffTime() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kAutoOffDuration;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询debug开关*/
List<int> queryDebugSwitch() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kDebugSwitch;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询BT开关*/
List<int> querybBTSwitch() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kBTAuto;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询321预备开关*/
List<int> querypRESwitch() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = k321Pre;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询长按*/
List<int> queryLongProgress() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kLongPressCheck;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询蓝牙名称*/
List<int> queryBLTName() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kBLTName;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*查询蓝牙mac地址*/
List<int> queryBLTMac() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = kBLTMacAdress;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*关机*/
List<int> turnoff() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x10;
  int data = 0x01;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*reboot*/
List<int> reboot() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x10;
  int data = 0x02;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*重置自动关机时间*/
List<int> resetOffTime() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x10;
  int data = 0x03;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*设置通信通道*/
List<int> setChannel(int channel) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = kChannel;
  int data2 = channel;
  int cs = start + source + destination + length + cmd + data + data2;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data2, cs, end];
}

/*设置干扰容错级别*/
List<int> setReferenceLevell(int level) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = kReferenceLevel;
  int data2 = level;
  int cs = start + source + destination + length + cmd + data + data2;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data2, cs, end];
}

/*设置自动关机时间*/
List<int> setAutoOffTime(int minute) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 12;
  int cmd = 0x10;
  int data = kAutoOffDuration;
  int value = minute * 60 * 1000;

  if (value < 0) {
    return [];
  }
  String binary = '';
  while (value > 0) {
    binary = (value % 2).toString() + binary;
    value = value ~/ 2;
  }
  binary = binary.padLeft(32, '0');

  int data4 = StringUtil.binaryStringToDecimal(binary.substring(0, 8));
  int data3 = StringUtil.binaryStringToDecimal(binary.substring(8, 16));
  int data2 = StringUtil.binaryStringToDecimal(binary.substring(16, 24));
  int data1 = StringUtil.binaryStringToDecimal(binary.substring(24, 32));

  int cs = start +
      source +
      destination +
      length +
      cmd +
      data +
      data1 +
      data2 +
      data3 +
      data4;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [
    start,
    source,
    destination,
    length,
    cmd,
    data,
    data1,
    data2,
    data3,
    data4,
    cs,
    end
  ];
}

/*设置debug开关*/
List<int> setDebug(bool debug) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = kDebugSwitch;
  int data2 = debug ? 0x01 : 0x00;
  int cs = start + source + destination + length + cmd + data + data2;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data2, cs, end];
}

/*设置BT开关*/
List<int> setBT(bool debug) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = kBTAuto;
  int data2 = debug ? 0x01 : 0x00;
  int cs = start + source + destination + length + cmd + data + data2;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data2, cs, end];
}

/*设置321Pre开关*/
List<int> setPre(bool debug) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = 0x12;
  int data2 = debug ? 0x01 : 0x00;
  int cs = start + source + destination + length + cmd + data + data2;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data2, cs, end];
}

/*重置蓝牙模块*/
List<int> resetBLT() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x10;
  int data = kBLTReset;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*恢复出厂设置*/
List<int> resetFactory() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x10;
  int data = kFactoryReset;
  int cs = start + source + destination + length + cmd + data;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, cs, end];
}

/*长按检测*/
List<int> setLongProgress(int value) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = kLongPressCheck;
  int data1 = value;
  int cs = start + source + destination + length + cmd + data + data1;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data1, cs, end];
}

/*设置蓝牙mac地址*/
List<int> setBLTMac(String mac) {
  if (mac.length != 12) {
    return [];
  }
  String text1 = mac.substring(0, 2);
  String text2 = mac.substring(2, 4);
  String text3 = mac.substring(4, 6);
  String text4 = mac.substring(6, 8);
  String text5 = mac.substring(8, 10);
  String text6 = mac.substring(10, 12);
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 14;
  int cmd = 0x10;
  int data = kBLTMacAdress;
  int data1 = int.parse(text1, radix: 16);
  int data2 = int.parse(text2, radix: 16);
  int data3 = int.parse(text3, radix: 16);
  int data4 = int.parse(text4, radix: 16);
  int data5 = int.parse(text5, radix: 16);
  int data6 = int.parse(text6, radix: 16);
  int cs = start +
      source +
      destination +
      length +
      cmd +
      data +
      data1 +
      data2 +
      data3 +
      data4 +
      data5 +
      data6;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [
    start,
    source,
    destination,
    length,
    cmd,
    data,
    data1,
    data2,
    data3,
    data4,
    data5,
    data6,
    cs,
    end
  ];
}

/*设置蓝牙名称*/
List<int> setBLTName(String name) {
  if (name.length > 16) {
    return [];
  }
  List<int> nameValues = [];
  for (int i = 0; i < 16; i++) {
    if (i >= name.length) {
      nameValues.add(0);
    } else {
      String text = name.substring(i, i + 1);
      int asciiCode = text.codeUnitAt(0);
      nameValues.add(asciiCode);
    }
  }
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 24;
  int cmd = 0x10;
  int data = kBLTName;
  int cs = start + source + destination + length + cmd + data;

  for (int i = 0; i < nameValues.length; i++) {
    cs = cs + nameValues[i];
  }
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  List<int> finalValue = [
    start,
    source,
    destination,
    length,
    cmd,
    data,
  ];
  for (int i = 0; i < nameValues.length; i++) {
    finalValue.add(nameValues[i]);
  }
  finalValue.add(cs);
  finalValue.add(end);
  print('finalValue = ${finalValue}');
  return finalValue;
}
