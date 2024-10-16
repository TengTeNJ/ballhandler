import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

enum BLEModelStatu {
  virtual, // 虚拟 仅仅在列表上展示
  notconnected, // 发现了 未连接
  conected, //  已连接
}

class BLEModel {
  String deviceName;
  bool powerOn = false; // 开机状态
  int powerValue = 100; // 电量值
  DiscoveredDevice? device; // 蓝牙设备信息
  bool? hasConected; // 连接状态
  bool is270 = false;
  QualifiedCharacteristic? notifyCharacteristic; // notify特征值
  QualifiedCharacteristic? writerCharacteristic; // writer特征值
  StreamSubscription<ConnectionStateUpdate>? bleStream;
   int get batteryLevel{
     if(this.powerValue >80){
       return 5;
     }else  if(this.powerValue >60 && this.powerValue <= 80){
       return 4;
     }else  if(this.powerValue >40 && this.powerValue <= 60){
       return 3;
     }else  if(this.powerValue >20 && this.powerValue <= 40){
       return 2;
     }else  if( this.powerValue <= 20){
       return 1;
     }
    return 5;
   } // 电量等级
  BLEModel(
      {required this.deviceName,
      this.device,
      this.hasConected = false,
      this.notifyCharacteristic,
      this.writerCharacteristic,
      this.powerValue = 100});

  BLEModelStatu get modelStatu {
    if (this.device == null) {
      return BLEModelStatu.virtual;
    } else if (this.hasConected == true) {
      return BLEModelStatu.conected;
    } else {
      return BLEModelStatu.notconnected;
    }
  }
}
