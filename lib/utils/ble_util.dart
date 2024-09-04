import 'package:code/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import '../constants/constants.dart';
import 'color.dart';
import 'global.dart';
import 'package:open_settings/open_settings.dart';

class BleUtil {
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
}
