import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  /*获取系统版本*/
  static Future<String> getApplicationVersion() async{
    final info = await PackageInfo.fromPlatform();
    return info.version + '#' + info.buildNumber;
  }
}
