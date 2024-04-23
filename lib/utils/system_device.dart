import 'package:flutter/services.dart';

class SystemUtil {
  /*锁定屏幕为竖屏*/
  static lockScreenDirection(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  /*恢复屏幕可横竖屏切换*/
  static resetScreenDirection(){
// 允许屏幕旋转
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
  }
}