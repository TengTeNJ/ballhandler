/*270度灯光以及其他控制数据组装*/
/*
	根据蓝牙主从一体网络拓扑，所有角色定义如下：上位机（手机）- Master，1个主控面板（主从一体）- Central，以及5个从面板 – Slave。
	所有角色的设备地址定义按位映射表示如下：
  bit[7]: 上位机；
  bit[6]：保留；
  bit[5:1]：5-1号从板；
  bit[0]：主控板
* */
import 'package:code/constants/constants.dart';

/*
* 控制某面板灯光
* boradIndex为灯光索引，0为主控板 1-5为从板
* lightStatu为灯板对应的四个灯光的的开关状态 顺序为 0 ，1，2，3
* */
List<int> controRedLightBoard(int boradIndex, List<int> lightStatu) {
  if (ISEmpty(lightStatu) || lightStatu.length != 4) {
    throw Exception('清输入面板上每个灯光的开关状态，每个面板有4个灯');
  }
  if (boradIndex < 0 || boradIndex > 5) {
    throw Exception('面板的索引范围是[0-5],而你的索引为${boradIndex}');
  }
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  // 数据源地址 从app发送的都是位上位机
  int source = int.parse('10000000', radix: 2);
  // 数据目的地址
  int destinationInt;
  String destination = '00';
  if (boradIndex == 0) {
    // 目的设备是主控板
    destinationInt = int.parse('00000001', radix: 2);
  } else {
    // 目的设备是1-5号从板
    for (int i = 5; i >= 1; i--) {
      destination = destination + ((i == boradIndex ) ? '1' : '0');
    }
    destination = destination + '0';
    destinationInt = int.parse(destination, radix: 2);
  }

  int length = 7;
  int cmd = 0x60;

  // Data
  int data1 = int.parse('00001111', radix: 2);
  String lights = '';
  for (int j = 3; j >= 0; j--) {
    int value = lightStatu[j];
    if (value == 1) {
      // 开灯
      lights = lights + '01';
    } else {
      // 关灯
      lights = lights + '00';
    }
  }

  int data2 = int.parse(lights, radix: 2);

  int cs = start + source + destinationInt + length + cmd + data1 + data2;
  return [start, source, destinationInt, length, cmd, data1, data2, cs, end];
}

/*
* 控制某面板灯光
* boradIndex为灯光索引，0为主控板 1-5为从板
* lightStatu为灯板对应的四个灯光的的开关状态
* */
List<int> controBlueLightBoard(int boradIndex, List<int> lightStatu) {
  if (ISEmpty(lightStatu) || lightStatu.length != 4) {
    throw Exception('清输入面板上每个灯光的开关状态，每个面板有4个灯');
  }
  if (boradIndex < 0 || boradIndex > 5) {
    throw Exception('面板的索引范围是[0-5],而你的索引为${boradIndex}');
  }
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  // 数据源地址 从app发送的都是位上位机
  int source = int.parse('10000000', radix: 2);
  // 数据目的地址
  int destinationInt;
  String destination = '00';
  if (boradIndex == 0) {
    // 目的设备是主控板
    destinationInt = int.parse('00000001', radix: 2);
  } else {
    // 目的设备是1-5号从板
    for (int i = 5; i >=1; i--) {
      destination = destination + ((i == boradIndex) ? '1' : '0');
    }
    destination = destination + '0';
    destinationInt = int.parse(destination, radix: 2);
  }

  int length = 7;
  int cmd = 0x60;

  String lights = '';
  int data1 = int.parse('00001111', radix: 2);
  for (int j = 3; j >= 0; j--) {
    int value = lightStatu[j];
    // 0b00-关灯; 0b01-红灯; 0b10-蓝灯;
    if (value == 1) {
      // 开灯
      lights = lights + '10';
    } else {
      // 关灯
      lights = lights + '00';
    }
  }
  int data2 = int.parse(lights, radix: 2);

  int cs = start + source + destinationInt + length + cmd + data1 + data2;
  return [start, source, destinationInt, length, cmd, data1, data2, cs, end];
}

/*
* 关闭所有的面板灯光
* */
List<int> closeAllBoardLight() {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00111111', radix: 2);
  int length = 7;
  int cmd = 0x36;
  int data1 = int.parse('00001111', radix: 2);
  int data2 = int.parse('00000000', radix: 2);

  int cs = start + source + destination + length + cmd + data1 + data2;
  return [start, source, destination, length, cmd, data1, data2, cs, end];
}

/*关闭某个面板的所有灯光
* boardIndex面板的索引
* */
List<int> closeSomeOneBoardLight(int boardIndex) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  // 数据目的地址
  int destinationInt;
  String destination = '00';
  if (boardIndex == 0) {
    // 目的设备是主控板
    destinationInt = int.parse('00000001', radix: 2);
  } else {
    // 目的设备是1-5号从板
    for (int i = 1; i < 6; i++) {
      destination = destination + ((i == boardIndex - 1) ? '1' : '0');
    }
    destination = destination + '0';
    destinationInt = int.parse(destination, radix: 2);
  }
  int length = 7;
  int cmd = 0x36;
  int data1 = int.parse('00001111', radix: 2);
  int data2 = int.parse('00000000', radix: 2);
  int cs = start + source + destinationInt + length + cmd + data1 + data2;
  return [start, source, destinationInt, length, cmd, data1, data2, cs, end];
}

/*
* 打开所有的面板灯光,默认为红灯
* */
List<int> openAllBoardLight({bool isRed = true}) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00111111', radix: 2);
  int length = 7;
  int cmd = 0x36;
  int data1;
  int data2;
  if (isRed) {
    // 显示为红灯
    data1 = int.parse('00001111', radix: 2);
    data2 = int.parse('01010101', radix: 2);
  } else {
    // 显示为蓝灯
    data1 = int.parse('00001111', radix: 2);
    data2 = int.parse('10101010', radix: 2);
  }
  int cs = start + source + destination + length + cmd + data1 + data2;
  return [start, source, destination, length, cmd, data1, data2, cs, end];
}

/*打开某个面板的灯光
* boardIndex面板的索引
* */
List<int> openSomeOneBoardLight(int boardIndex, {bool isRed = true}) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  // 数据目的地址
  int destinationInt;
  String destination = '00';
  if (boardIndex == 0) {
    // 目的设备是主控板
    destinationInt = int.parse('00000001', radix: 2);
  } else {
    // 目的设备是1-5号从板
    for (int i = 1; i < 6; i++) {
      destination = destination + ((i == boardIndex - 1) ? '1' : '0');
    }
    destination = destination + '0';
    destinationInt = int.parse(destination, radix: 2);
  }
  int length = 7;
  int cmd = 0x36;
  int data1;
  int data2;
  if (isRed) {
    // 显示为红灯
    data1 = int.parse('00001111', radix: 2);
    data2 = int.parse('01010101', radix: 2);
  } else {
    // 显示为蓝灯
    data1 = int.parse('00001111', radix: 2);
    data2 = int.parse('10101010', radix: 2);
  }
  int cs = start + source + destinationInt + length + cmd + data1 + data2;
  return [start, source, destinationInt, length, cmd, data1, data2, cs, end];
}

/*
* 控制模式
* 1: APP控制进入P1模式；
  2: APP控制进入P2模式；
  3: APP控制进入P3模式；
* */
List<int> selectMode(int mode) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 6;
  int cmd = 0x03;
  int data = mode;
  int cs = start + source + destination + length + cmd + data;
  return [start, source, destination, length, cmd, data, cs, end];
}

/*
* 倒计时显示
* value为倒计时显示的值
* isGo为true代表显示GO
* */
List<int> cutDownShow({int value = 0, bool isGo = false}) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x05;
  int data1 = 0x01;
  int data2;
  int data3;
  int data4;
  if (isGo) {
    // 显示Go
    data2 = 0;
    data3 = 0x47;
    data4 = 0x4f;
  } else {
    // 显示倒计时 3,2,1
    data2 = 0x30;
    data3 = 0x30;
    data4 = 0x30 + value;
  }
  int cs = start +
      source +
      destination +
      length +
      cmd +
      data1 +
      data2 +
      data3 +
      data4;
  return [
    start,
    source,
    destination,
    length,
    cmd,
    data1,
    data2 + data3 + data4,
    cs,
    end
  ];
}

/*
* 显示得分
* value为当前得分
* */
List<int> scoreShow(int value) {
  int start = kBLEDataFrameHeader;
  int end = kBLEDataFramerFoot;
  int source = int.parse('10000000', radix: 2);
  int destination = int.parse('00000001', radix: 2);
  int length = 9;
  int cmd = 0x05;

  int data1 = 0x02;
  String score = value.toString().padLeft(3, '0');
  int data2;
  int data3;
  int data4;
  //  得分
  data2 = 0x30 + int.parse(score.substring(0, 2));
  data3 = 0x30 + int.parse(score.substring(1, 3));
  data4 = 0x30 + int.parse(score.substring(2, 4));

  int cs = start +
      source +
      destination +
      length +
      cmd +
      data1 +
      data2 +
      data3 +
      data4;
  return [
    start,
    source,
    destination,
    length,
    cmd,
    data1,
    data2 + data3 + data4,
    cs,
    end
  ];
}
