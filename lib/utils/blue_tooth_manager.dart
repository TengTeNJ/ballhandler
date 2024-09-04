import 'dart:async';
import 'dart:io';
import 'package:code/constants/constants.dart';
import 'package:code/models/global/game_data.dart';
import 'package:code/utils/ble_data.dart';
import 'package:code/utils/ble_data_service.dart';
import 'package:code/utils/ble_ultimate_data.dart';
import 'package:code/utils/ble_ultimate_service_data.dart';
import 'package:code/utils/control_time_out_util.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import '../models/ble/ble_model.dart';
import 'global.dart';
import 'notification_bloc.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  final _ble = FlutterReactiveBle();

  factory BluetoothManager() {
    _instance.listenBLEStatu();
    return _instance;
  }

  BluetoothManager._internal();

  // 蓝牙列表
  List<BLEModel> deviceList = [];

  // 页面上展示的蓝牙列表
  List<BLEModel> get showDeviceList {
    List<BLEModel> virtualList = [];
    kBLEDevice_ReleaseNames.forEach((element) {
      BLEModel model = BLEModel(deviceName: element);
      virtualList.add(model);
    });
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.gameScene;
    // 获取到当前游戏的场景模式 并置顶
    final _topDeviceName = kBLEDevice_ReleaseNames[gameUtil.gameScene.index];
    // 置顶当前场景的元素
    final _model = virtualList
        .firstWhere((virtual) => virtual.deviceName == _topDeviceName);
    if (_model != null) {
      virtualList.remove(_model);
      virtualList.insert(0, _model);
    }
    // 如果搜索到的设备列表中已经有了这样的设备 就移除虚拟设备
    this.deviceList.forEach((element) {
      if (kBLEDevice_ReleaseNames.contains(element.device!.name)) {
        final _model = virtualList.firstWhere(
            (virtual) => virtual.deviceName == element.device!.name);
        virtualList.remove(_model);
      }
      // 把已连接的放到前面
      virtualList.insert(0, element);
    });
    // 最后需要把搜索到的设备置顶
    return virtualList;
  }

  // 已经完成蓝牙连接的设备列表
  List<BLEModel> get hasConnectedDeviceList {
    List<BLEModel> connectedDeviceList = [];
    this.deviceList.forEach((element) {
      if (element.hasConected != null && element.hasConected == true) {
        connectedDeviceList.add(element);
      }
    });
    return connectedDeviceList;
  }

  // 游戏数据
  GameData gameData = GameData();

  Function(BLEDataType type)? dataChange;

  Function(BLEDataType type)?
      p3DataChange; // p3模式下数据监听 监听集中。如果都用dataChange，那么dataChange会覆盖。但是数据监听需要再util和controller都要使用

  final ValueNotifier<int> deviceListLength = ValueNotifier(-1);

  // 已连接的设备数量
  final ValueNotifier<int> conectedDeviceCount = ValueNotifier(0);

  Stream<DiscoveredDevice>? _scanStream;
  StreamSubscription? _bleListen;
  StreamSubscription? _bleStatuListen;

  /*开始扫描*/
  Future<void> startScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      return;
    }

    if (_scanStream == null) {
      _scanStream = _ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      );
      _bleListen = _scanStream!.listen((DiscoveredDevice event) {
        // 处理扫描到的蓝牙设备
        // print('event.name=${event.name}');
        //model.deviceName .contains(k270_Name)
        // kBLEDevice_Names.indexOf(event.name) != -1
        if (event.name.contains(k270_Name) ||
            kBLEDevice_Names.indexOf(event.name) != -1) {
          // 如果设备列表数组中无，则添加
          if (!hasDevice(event.id)) {
            this
                .deviceList
                .add(BLEModel(deviceName: event.name, device: event));
            deviceListLength.value = this.deviceList.length;
          } else {
            // 设备列表数组中已有，则忽略
          }
        }
      });
    }
  }

  /*连接设备*/
  conectToDevice(BLEModel model) {
    if (model.hasConected == true) {
      // 已连接状态直接返回
      return;
    }

    EasyLoading.show();
    StreamSubscription<ConnectionStateUpdate> stream = _ble
        .connectToDevice(
            id: model.device!.id, connectionTimeout: Duration(seconds: 30))
        .listen((ConnectionStateUpdate connectionStateUpdate) {
      print('connectionStateUpdate = ${connectionStateUpdate.connectionState}');
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // 连接设备数量+1
        conectedDeviceCount.value++;
        // 已连接
        model.hasConected = true;
        final notifyCharacteristic;
        final writerCharacteristic;
        if (model.deviceName.contains(k270_Name)) {
          // 保存读写特征值 270设备
          notifyCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_270_SERVICE_UUID),
              characteristicId: Uuid.parse(kBLE_270_CHARACTERISTIC_NOTIFY_UUID),
              deviceId: model.device!.id);
          writerCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_270_SERVICE_UUID),
              characteristicId: Uuid.parse(kBLE_270_CHARACTERISTIC_WRITER_UUID),
              deviceId: model.device!.id);
          model.notifyCharacteristic = notifyCharacteristic;
          model.writerCharacteristic = writerCharacteristic;
          // 发送 APP上线
          BluetoothManager().writerDataToDevice(model, appOnLine());
          // 查询主机状态
          BluetoothManager()
              .writerDataToDevice(model, queryMasterSystemStatu());
        } else {
          // 保存读写特征值
          notifyCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_SERVICE_NOTIFY_UUID),
              characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_NOTIFY_UUID),
              deviceId: model.device!.id);
          writerCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
              characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
              deviceId: model.device!.id);
          model.notifyCharacteristic = notifyCharacteristic;
          model.writerCharacteristic = writerCharacteristic;
        }
        // 连接成功弹窗
        EasyLoading.showSuccess('Bluetooth connection successful',
            maskType: EasyLoadingMaskType.black);
        // 监听数据
        _ble
            .subscribeToCharacteristic(notifyCharacteristic)
            .listen((List<int> data) {
          if (model.deviceName.contains(k270_Name)) {
            print(
                "deviceName =${model.device!.name} 上报来的数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
            // 解析270
            BluetoothUltTimateDataParse.parseData(data, model);
          } else {
            // 解析五节
            BluetoothDataParse.parseData(data, model);
          }
        });
        writerDataToDevice(model, questDeviceInfoData());
        // 连接成功，则设备列表页面弹窗消失
        NavigatorUtil.pop();
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
        EasyLoading.showError('disconected');
        if (conectedDeviceCount.value > 0) {
          conectedDeviceCount.value--;
          if (conectedDeviceCount.value == 0) {
            // 所有设备断开
            _instance._bleListen?.cancel();
            _instance._bleListen = null;
            _instance._scanStream = null;
          }
        }
        // 失去连接
        model.hasConected = false;
        this.deviceList.remove(model);
        // 说明是当前选择的游戏设备 并且断开了连接
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        if (gameUtil.selectedDeviceModel.device != null &&
            gameUtil.selectedDeviceModel.device!.id == model.device!.id) {
          EventBus().sendEvent(kCurrentDeviceDisconnected);
        }
        deviceListLength.value = this.deviceList.length;
      }
    });
    // 保存sream
    model.bleStream = stream;
  }

  /*断开连接*/
  disconecteDevice(BLEModel device) {
    device.bleStream?.cancel();
    EasyLoading.showToast('Disconnected');
    if (conectedDeviceCount.value > 0) {
      conectedDeviceCount.value--;
      if (conectedDeviceCount.value == 0) {
        // 所有设备断开
        _instance._bleListen?.cancel();
        _instance._bleListen = null;
        _instance._scanStream = null;
      }
    }
    device.hasConected = false;
    // 发送通知 主动断开
    EventBus().sendEvent(kInitiativeDisconnect);
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
    if (data[4] == 0x60 && data[2] != 0x7f) {
      print(
          " 重发数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
    }

    // 多个命令同时发时 增加10ms的时间间隔
    sleep(Duration(milliseconds: 10));
    await _ble.writeCharacteristicWithoutResponse(model.writerCharacteristic!,
        value: data);
  }

  /*增加超时机制的控制*/
  Future<bool> asyncWriterDataToDevice(BLEModel model, List<int> data) async {
    //  数据校验
    if (data == null || data.length == 0) {
      ControlTimeOutUtil().completer.complete(true);
      ControlTimeOutUtil().completer = Completer();
    }
    // 确认蓝牙设备已连接 并保存对应的特征值
    if (model == null ||
        model.hasConected == null ||
        model.writerCharacteristic == null) {
      TTToast.showErrorInfo('Please connect your device first');
      ControlTimeOutUtil().completer.complete(true);
      ControlTimeOutUtil().reset();
    }
    ControlTimeOutUtil().controling.value = true;
    ControlTimeOutUtil().controlBoard = data[2];
    print(
        " 发数据data = ${data.map((toElement) => toElement.toRadixString(16)).toList()}");
    _ble.writeCharacteristicWithoutResponse(model.writerCharacteristic!,
        value: data);
    // 解析270
    // 记录缓存发送的数据
    ControlTimeOutUtil().ongoingData = data;
    // 超时重发逻辑
    ControlTimeOutUtil().begainTimer();
    return ControlTimeOutUtil().completer.future;
  }

  /*判断是否已经被添加设备列表*/
  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
        this.deviceList.where((element) => element.device!.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  /*停止扫描*/
  stopScan() {
    //_scanStream = null;
  }

  listenBLEStatu() {
    if (_bleStatuListen == null) {
      _bleStatuListen = FlutterReactiveBle().statusStream.listen((status) {
        print('蓝牙状态status===${status}');
        GameUtil gameUtil = GetIt.instance<GameUtil>();
        gameUtil.bleStatus = status;
        if (status == BleStatus.poweredOff) {
          // 蓝牙开关关闭
          _instance._bleListen?.cancel();
          _instance._bleListen = null;
          _instance._scanStream = null;
        } else if (status == BleStatus.locationServicesDisabled) {
          // 安卓位置权限不允许
        } else if (status == BleStatus.unauthorized) {
          // 未授权蓝牙权限
        } else if (status == BleStatus.ready) {}
      });
    }
  }

  triggerCallback({BLEDataType type = BLEDataType.none}) {
    dataChange?.call(type);
  }

  p3TriggerCallback({BLEDataType type = BLEDataType.none}) {
    p3DataChange?.call(type);
  }
}
