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
      if(element.hasConected != null && element.hasConected == true ){
        connectedDeviceList.add(element);
      }
    });
    return connectedDeviceList;
  }

  // 游戏数据
  GameData gameData = GameData();

  Function(BLEDataType type)? dataChange;

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

    if(_scanStream == null){
      _scanStream = _ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      );
      _bleListen =_scanStream!.listen((DiscoveredDevice event) {
        // 处理扫描到的蓝牙设备
        // print('event.name=${event.name}');
        if (kBLEDevice_Names.indexOf(event.name) != -1) {
          // 如果设备列表数组中无，则添加
          if (!hasDevice(event.id)) {
            this.deviceList.add(BLEModel(deviceName: event.name, device: event));
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
    _ble
        .connectToDevice(
            id: model.device!.id, connectionTimeout: Duration(seconds: 10))
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
            deviceId: model.device!.id);
        final writerCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
            deviceId: model.device!.id);
        model.notifyCharacteristic = notifyCharacteristic;
        model.writerCharacteristic = writerCharacteristic;
        // 连接成功弹窗
        EasyLoading.showSuccess('Bluetooth connection successful');
        // 监听数据
        _ble.subscribeToCharacteristic(notifyCharacteristic).listen((data) {
          print("deviceId =${model.device!.id}---上报来的数据data = $data");
          BluetoothDataParse.parseData(data,model);
        });
        writerDataToDevice(model,questDeviceInfoData());
        // 连接成功，则设备列表页面弹窗消失
        NavigatorUtil.pop();
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
        EasyLoading.showError('disconected');
        if (conectedDeviceCount.value > 0) {
          conectedDeviceCount.value--;
          if(conectedDeviceCount.value == 0){
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
        if(gameUtil.selectedDeviceModel.device != null && gameUtil.selectedDeviceModel.device!.id == model.device!.id){
          EventBus().sendEvent(kCurrentDeviceDisconnected);
        }
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
        this.deviceList.where((element) => element.device!.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  /*停止扫描*/
  stopScan() {
    //_scanStream = null;
  }

  listenBLEStatu(){
    if(_bleStatuListen == null){
      _bleStatuListen =  FlutterReactiveBle().statusStream.listen((status) {
        print('蓝牙状态status===${status}');
        //code for handling status updatei
        if(status == BleStatus.poweredOff){
          // 蓝牙开关关闭
          _instance._bleListen?.cancel();
          _instance._bleListen = null;
          _instance._scanStream = null;
        }else if(status == BleStatus.locationServicesDisabled){
          // 安卓位置权限不允许
        }else if(status == BleStatus.unauthorized){
          // 未授权蓝牙权限
        }else if(status == BleStatus.ready){

        }
      });
    }

  }

  triggerCallback({BLEDataType type = BLEDataType.none}) {
    dataChange?.call(type);
  }
}
