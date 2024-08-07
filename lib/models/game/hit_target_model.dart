import 'package:code/utils/ble_ultimate_service_data.dart';
/*击中的标靶数据模型 或者 app控制的标靶的数据模型*/
class HitTargetModel {
  int boardIndex; // 灯板编号 0,1,2,3,4,5  其中0是central  其他是从机Slave
  int ledIndex; // 每个面板上的灯的编号的index 0,1,2,3
  BleULTimateLighStatu statu; // 每个灯的状态
  HitTargetModel(
      {required this.boardIndex, required this.ledIndex, required this.statu});
}

class ClickTargetModel {
  int boardIndex; // 灯板编号 0,1,2,3,4,5  其中0是central  其他是从机Slave
  List<int> ledIndex; // 每个面板上的灯的编号的index 0,1,2,3数组，要控制的灯的索引数组
  List<BleULTimateLighStatu> statu; // 每个灯的状态 和ledIndexs对应
  ClickTargetModel(
      {required this.boardIndex, required this.ledIndex, required this.statu});
}

