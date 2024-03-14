import 'package:flutter/material.dart';

class NavigatorUtil {
  static late  BuildContext _context;

  // 设置NavigatorState，通常在应用启动时调用
  static void init(BuildContext context) {
    print('---context, = ${context}');
    _context = context;
  }

  // 跳转到新页面（push）
  static  push (String routeName) {
    print('--------');
    print('NavigatorUtil.context, = ${NavigatorUtil._context}');
    return  Navigator.pushNamed(NavigatorUtil._context, routeName);
  }
}




