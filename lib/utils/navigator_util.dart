import 'package:code/utils/system_device.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class NavigatorUtil {
  static late BuildContext utilContext;

  // 设置NavigatorState，通常在应用启动时调用
  static void init(BuildContext context) {
    utilContext = context;
  }

  // 跳转到新页面（push）
  static push(String routeName,{Object arguments = const Object()}) {
    return Navigator.pushNamed(NavigatorUtil.utilContext, routeName,arguments: arguments);
  }

  //  出栈（pop）
  static pop() {
    return Navigator.of(NavigatorUtil.utilContext).pop();
  }

  static popAndThenPush(String routeName,{Object arguments = const Object()}){
    return Navigator.of(NavigatorUtil.utilContext).popAndPushNamed(routeName,arguments: arguments);
  }

  //  模态效果
  static present(Widget widget,{String routesName = '',Object arguments = const Object()}) async{
    if( await  SystemUtil.isIPad() && routesName.length > 0){
      // iPad的话 showModalBottomSheet不能全屏幕 有问题
      print('routesName=${routesName}');
      push(routesName,arguments: arguments);
    }else{
      showModalBottomSheet(
        isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
        context: NavigatorUtil.utilContext,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.95,
            child: widget,
          );
        },
      );
    }
  }

  // 跳转到根试图
  static popToRoot(){
    Navigator.of(NavigatorUtil.utilContext).popUntil((route) => route.isFirst);
  }
}

