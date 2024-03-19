import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() {
    return _instance;
  }
  BluetoothManager._internal();

  final _ble = FlutterReactiveBle();

  /*开始扫描*/
  Future<void> startScan() async {
    _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((event) {
      // 处理扫描到的蓝牙设备
      print('Found device: ${event.name}');
    });
  }

}