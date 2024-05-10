import 'dart:async';
import 'package:code/constants/constants.dart';
import 'package:code/models/global/game_data.dart';
import 'package:code/utils/ble_data.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import '../models/ble/ble_model.dart';
import 'global.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  final _ble = FlutterReactiveBle();

  // 蓝牙列表
  List<BLEModel> deviceList = [];

  // 游戏数据
  GameData gameData = GameData();

  Function(BLEDataType type)? dataChange;

  final ValueNotifier<int> deviceListLength = ValueNotifier(-1);

  // 已连接的设备数量
  final ValueNotifier<int> conectedDeviceCount = ValueNotifier(0);

  Stream<DiscoveredDevice>? _scanStream;

  /*开始扫描*/
  Future<void> startScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      return;
    }
    _scanStream = _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    );
    _scanStream!.listen((DiscoveredDevice event) {
      // 处理扫描到的蓝牙设备
      // print('event.name=${event.name}');
      if (kBLEDevice_Names.indexOf(event.name) != -1) {
        // 如果设备列表数组中无，则添加
        if (!hasDevice(event.id)) {
          this.deviceList.add(BLEModel(device: event));
          deviceListLength.value = this.deviceList.length;
        } else {
          // 设备列表数组中已有，则忽略
        }
      }
    });
  }

  /*连接设备*/
  conectToDevice(BLEModel model) {
    if (model.hasConected == true) {
      // 已连接状态直接返回
      return;
    }
    EasyLoading.show();
    _ble
        .connectToDevice(
            id: model.device.id, connectionTimeout: Duration(seconds: 10))
        .listen((ConnectionStateUpdate connectionStateUpdate) {
      print('connectionStateUpdate = ${connectionStateUpdate.connectionState}');
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // 连接设备数量+1
        conectedDeviceCount.value++;
        // 已连接
        model.hasConected = true;
        // 保存读写特征值
        final notifyCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_NOTIFY_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_NOTIFY_UUID),
            deviceId: model.device.id);
        final writerCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
            deviceId: model.device.id);
        model.notifyCharacteristic = notifyCharacteristic;
        model.writerCharacteristic = writerCharacteristic;
        // 打开毫秒使能开关
        print('onLineData=${onLineData()}');
       writerDataToDevice(model, onLineData());
        // 连接成功弹窗
        EasyLoading.showSuccess('Bluetooth connection successful');
        // 监听数据
        _ble.subscribeToCharacteristic(notifyCharacteristic).listen((data) {
          //print("deviceId =${model.device.id}---上报来的数据data = $data");
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          // 在游戏页面 才处理数据
          if (gameUtil.nowISGamePage) {
            BluetoothDataParse.parseData(data);
          }
        });
        // 连接成功，则设备列表页面弹窗消失
        NavigatorUtil.pop();
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
        EasyLoading.showError('disconected');
        if(conectedDeviceCount.value > 0){
          conectedDeviceCount.value--;
        }
        // 失去连接
        model.hasConected = false;
        this.deviceList.remove(model);
        deviceListLength.value = this.deviceList.length;
      }
    });
  }

  /*发送数据*/
  writerDataToDevice(BLEModel model, List<int> data) async {
    //  数据校验
    if (data == null || data.length == 0) {
      return;
    }
    // 确认蓝牙设备已连接 并保存对应的特征值
    if (model == null ||
        model.hasConected == null ||
        model.writerCharacteristic == null) {
      TTToast.showErrorInfo('Please connect your device first');
      return;
    }
    print('data=${data}');
    await _ble.writeCharacteristicWithoutResponse(model.writerCharacteristic!,
        value: data);
  }

  /*判断是否已经被添加设备列表*/
  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
        this.deviceList.where((element) => element.device.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  /*停止扫描*/
  stopScan() {
    //_scanStream = null;
  }

  triggerCallback({BLEDataType type = BLEDataType.none}) {
    dataChange?.call(type);
  }
}
