import 'package:code/utils/string_util.dart';

import '../constants/constants.dart';

/*查询通信通道*/
List<int> queryChannel() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 8;
  int cmd = 0x0E;
  int data = 0x04;
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
  int data = 0x05;
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
  int data = 0x06;
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
  int data = 0x07;
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
  int data = 0x08;
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
  int data = 0x09;
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
  int data = 0x04;
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
  int data = 0x05;
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
  int data = 0x06;
  int value = minute * 60 * 1000;

  if (value < 0) {
    return [];
  }
  String binary = '';
  while (value > 0) {
    binary = (value % 2).toString() + binary;
    value = value ~/ 2;
  }
  binary = binary.padLeft(32,'0');

  int data4 = StringUtil.binaryStringToDecimal(binary.substring(0,8));
  int data3 = StringUtil.binaryStringToDecimal(binary.substring(8,16));
  int data2 = StringUtil.binaryStringToDecimal(binary.substring(16,24));
  int data1 = StringUtil.binaryStringToDecimal(binary.substring(24,32));

  int cs = start + source + destination + length + cmd + data + data1 + data2 + data3 + data4;
  String binaryString = StringUtil.decimalToBinary(cs);
  if (binaryString.length > 8) {
    binaryString =
        binaryString.substring(binaryString.length - 8, binaryString.length);
  }
  cs = StringUtil.binaryStringToDecimal(binaryString);
  return [start, source, destination, length, cmd, data, data1,data2,data3,data4, cs, end];
}

/*设置debug开关*/
List<int> setDebug(bool debug) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x10;
  int data = 0x07;
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
  int data = 0x08;
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
  int data = 0x09;
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





