import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:url_launcher/url_launcher.dart';
class SystemUtil {
  /*锁定屏幕为竖屏*/
  static Future<void> lockScreenDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

/*锁定屏幕为横屏幕*/
  static Future<void> lockScreenHorizontalDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /*恢复屏幕可横竖屏切换*/
  static Future<void> resetScreenDirection() {
// 允许屏幕旋转
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
  }

  /*获取系统版本 包含build*/
  static Future<String> getApplicationVersion() async{
    final info = await PackageInfo.fromPlatform();
    return info.version + '#' + info.buildNumber;
  }

  /*获取系统版本 不包含build*/
  static Future<String> getApplicationOnlyVersion() async{
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /*判断是否是iPad*/
  static Future<bool> isIPad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // 根据平台获取设备信息
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      // 这里可以通过 iosDeviceInfo.model 来判断是否为 iPad
      // 例如，检查 model 是否包含 "iPad" 字符串
      return iosDeviceInfo.model.toLowerCase().contains('ipad');
    } else {
      // 对于非 iOS 设备，可以返回 false 或者进行其他检查
      return false;
    }
  }

  /*唤醒屏幕*/
  static wakeUpDevice(){
    WakelockPlus.enable();
  }

/*接触唤醒屏幕*/
  static disableWakeUpDevice(){
    WakelockPlus.disable();
  }

  /*隐藏状态栏*/
  static hiderStatuBar(bool hidden){

  }


  static jumpToStore() async {
    try {
      if (Platform.isIOS) {
        /// iOS App Store
        final Uri iosUrl = Uri.parse(
          'https://apps.apple.com/app/id6532593711',
        );
        if (await canLaunchUrl(iosUrl)) {
          await launchUrl(iosUrl, mode: LaunchMode.externalApplication);
        }
      } else if (Platform.isAndroid) {
        /// Android 优先 Google Play
        final Uri gpUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.potent.dangle',
        );

        if (await canLaunchUrl(gpUrl)) {
          await launchUrl(gpUrl, mode: LaunchMode.externalApplication);
        } else {
          /// 兜底：官网 / 应用宝 / 内置下载页
          final Uri backupUrl = Uri.parse(
            'https://你的官网下载地址',
          );
          await launchUrl(backupUrl, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print('❌ 跳转商店失败: $e');
    }
  }


}
