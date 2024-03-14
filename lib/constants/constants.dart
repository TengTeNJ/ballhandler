import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //  屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //  屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 状态栏高度
  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // 底部导航栏的高度，一般时动态获取的
  static Future<double> bottomBarHeight(BuildContext context) async {
    return MediaQuery.of(context).padding.bottom;
  }

  // 用于表示工具栏的默认高度，在Material Design中通常为56像素。工具栏用于显示应用程序的标题、操作按钮等内容。
  static double appBarHeight = kToolbarHeight;

  // 底部导航栏高度 默认为56像素
  static double tabBarHeight = kBottomNavigationBarHeight;

  static Color darkThemeColor = Color.fromRGBO(41, 41, 54, 1);
  static Color darkThemeOpacityColor = Color.fromRGBO(41, 41, 54, 0.24);
  static Color baseStyleColor = Color.fromRGBO(248, 133, 11, 1);
  static Color baseGreyStyleColor = Color.fromRGBO(177, 177, 177, 1);

  static Text regularBaseTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }
  static Text regularGreyTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }
  static Text regularWhiteTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }
  static Text mediumBaseTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }
  static Text mediumGreyTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }
  static Text mediumWhiteTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }
  static Text boldWhiteTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: fontSize),
    );
  }
  static Text boldBlackTextWidget(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(28, 30, 33, 1.0),
          fontSize: fontSize),
    );
  }

}

