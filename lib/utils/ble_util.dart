import 'dart:io';

import 'package:code/utils/dialog.dart';
import 'package:code/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/constants.dart';
import 'blue_tooth_manager.dart';
import 'color.dart';
import 'global.dart';
import 'package:open_settings/open_settings.dart';

class BleUtil {
  /*处理蓝牙状态*/
  static bool handleBleStatu(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    bool ready = false;
    switch (gameUtil.bleStatus) {
      case BleStatus.unknown:
        {
          TTToast.showToast('Please wait...');
          break;
        }
      case BleStatus.poweredOff:
        {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: hexStringToColor('#3E3E55'),
              title: Constants.boldWhiteTextWidget(
                  'Bluetooth is not turned on', 20,
                  textAlign: TextAlign.left),
              content: Constants.mediumWhiteTextWidget(
                  'Please turn on Bluetooth to use this feature.', 18,
                  textAlign: TextAlign.left),
              actions: <Widget>[
                TextButton(
                  child: Constants.mediumWhiteTextWidget('Cancel', 16,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Constants.mediumBaseTextWidget('Go to open', 16,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    // 跳转到系统设置页面，让用户开启位置权限
                    // 这里需要你根据平台实现跳转逻辑
                    OpenSettings.openBluetoothSetting();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          break;
        }

      case BleStatus.unauthorized:
        {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: hexStringToColor('#3E3E55'),
              title: Constants.boldWhiteTextWidget(
                  'Permission is not enabled', 20,
                  textAlign: TextAlign.left),
              content: Constants.mediumWhiteTextWidget(
                  'Please authorize the app to use Bluetooth in your device settings.',
                  16,
                  textAlign: TextAlign.left),
              actions: <Widget>[
                TextButton(
                  child: Constants.mediumWhiteTextWidget('Cancel', 16,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Constants.mediumBaseTextWidget('Go to authorize', 16,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    OpenSettings.openAppSetting();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          break;
        }
      case BleStatus.unsupported:
        {
          break;
        }
      case BleStatus.locationServicesDisabled:
        {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: hexStringToColor('#3E3E55'),
              title: Constants.boldWhiteTextWidget(
                  'Location permission is not enabled', 20,
                  textAlign: TextAlign.left),
              content: Constants.mediumWhiteTextWidget(
                  'We need your location permission to scan for Bluetooth devices',
                  18,
                  textAlign: TextAlign.left),
              actions: <Widget>[
                TextButton(
                  child: Constants.mediumWhiteTextWidget('Cancel', 16,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Constants.mediumBaseTextWidget('Go to open', 20,
                      textAlign: TextAlign.left),
                  onPressed: () {
                    // 跳转到系统设置页面，让用户开启位置权限
                    // 这里需要你根据平台实现跳转逻辑
                    OpenSettings.openManageApplicationSetting();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
          break;
        }
      case BleStatus.ready:
        {
          ready = true;
          break;
        }
        break;
    }
    return ready;
  }

  /*开始搜索*/
  static begainScan(BuildContext context) async {
    if (Platform.isAndroid) {
      PermissionStatus locationPermission = await Permission.location.request();
      PermissionStatus bleScan = await Permission.bluetoothScan.request();
      PermissionStatus bleConnect = await Permission.bluetoothConnect.request();
      if (locationPermission == PermissionStatus.granted &&
          bleScan == PermissionStatus.granted &&
          bleConnect == PermissionStatus.granted) {
        // 因为蓝牙监听那里不能立刻监听到 这里加延时处理
        Future.delayed(Duration(milliseconds: 600), () {
          bool result = BleUtil.handleBleStatu(context);
          if (result) {
            BluetoothManager().startScan();
          }
        });
      } else {
        BleUtil.handleBleStatu(context);
      }
    } else {
      bool result = BleUtil.handleBleStatu(context);
      if (result) {
        BluetoothManager().startScan();
      }
    }
  }

  static listenPowerValue(BuildContext context, int powerValue) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    if (powerValue > 30) {
      return;
    }
    if (gameUtil.gameScene == GameScene.erqiling) {
      if (gameUtil.uliLowPower2) {
        return;
      }
      // 270
      int index =
          BluetoothManager().gameData.p3DeviceBatteryValues.indexOf(powerValue);
      if (powerValue == 25) {
        if(gameUtil.uliLowPower1){
          return;
        }
        if (!gameUtil.nowISGamePage && !gameUtil.uliLowPower1) {
          gameUtil.uliLowPower1 = true;
          TTDialog.lowPowerTipDialog(context,
              boardIndex: index, powerValue: powerValue);
        }
      } else if (powerValue == 5) {
        gameUtil.uliLowPower2 = true;
        TTDialog.lowPowerTipDialog(context,
            boardIndex: index, powerValue: powerValue);
      }
    } else if (gameUtil.gameScene == GameScene.five) {
      // 五节
      if (gameUtil.fiveLowPower2) {
        return;
      }
      if (powerValue <= 30 && powerValue > 5) {
        if(gameUtil.fiveLowPower1){
          return;
        }
        if (!gameUtil.nowISGamePage && !gameUtil.fiveLowPower2) {
          gameUtil.fiveLowPower1 = true;
          TTDialog.lowPowerTipDialog(context,
              boardIndex: 0, powerValue: powerValue, isErQiLing: false);
        }
      } else if (powerValue <= 5) {
        gameUtil.fiveLowPower2 = true;
        TTDialog.lowPowerTipDialog(context,
            boardIndex: 0, powerValue: powerValue, isErQiLing: false);
      }
    }
  }
}
