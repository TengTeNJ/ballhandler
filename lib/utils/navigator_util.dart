import 'package:flutter/material.dart';

class NavigatorUtil {
  static late BuildContext _context;

  // 设置NavigatorState，通常在应用启动时调用
  static void init(BuildContext context) {
    _context = context;
  }

  // 跳转到新页面（push）
  static push(String routeName,{Object arguments = const Object()}) {
    return Navigator.pushNamed(NavigatorUtil._context, routeName,arguments: arguments);
  }

  //  出栈（pop）
  static pop() {
    return Navigator.of(NavigatorUtil._context).pop();
  }

  static popAndThenPush(String routeName,{Object arguments = const Object()}){
    return Navigator.of(NavigatorUtil._context).popAndPushNamed(routeName,arguments: arguments);
  }

  //  模态效果
  static present(Widget widget) {
    showModalBottomSheet(
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: NavigatorUtil._context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: widget,
        );
      },
    );
  }

  // 跳转到根试图
  static popToRoot(){
    Navigator.of(NavigatorUtil._context).popUntil((route) => route.isFirst);
  }
}
