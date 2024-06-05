import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

enum BLEModelStatu {
  virtual, // 虚拟 仅仅在列表上展示
  notconnected, // 发现了 未连接
  conected, //  已连接
}
class BLEModel {
  String deviceName;
  DiscoveredDevice? device; // 蓝牙设备信息
  bool? hasConected; // 连接状态
  QualifiedCharacteristic? notifyCharacteristic; // notify特征值
  QualifiedCharacteristic? writerCharacteristic; // writer特征值
  BLEModel(
      {required this.deviceName,
      this.device,
      this.hasConected = false,
      this.notifyCharacteristic,
      this.writerCharacteristic});

  BLEModelStatu get modelStatu{
    if(this.device == null){
      return BLEModelStatu.virtual;
    }else if(this.hasConected == true){
       return BLEModelStatu.conected;
    }else{
      return BLEModelStatu.notconnected;
    }

  }
}
