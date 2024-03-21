// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/participants/game_video_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/participants/training_mode_controller.dart';
import 'package:code/controllers/participants/video_check_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class Routes {
  static const String home = '/'; // 主页
  static const String login = 'login'; // 登录界面
  static const String privacy = 'privacy';
  static const String trainingMode = 'trainingMode'; // 训练模式选择
  static const String videocheck = 'videoCheck'; // 视频校验页面
  static const String gamevideo = 'gameVideo'; //  游戏界面，选择视频录制

  static RouteFactory onGenerateRoute = (settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePageController());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPageController());
      case privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPageController());
      case trainingMode:
        return MaterialPageRoute(builder: (_) => TrainingModeController());
      case videocheck:{
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_)=> VideoCheckController(camera: camera,));
      }
      case gamevideo:{
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_)=> GameVideoontroller(camera: camera,));
      }
        return _errorRoute();
    }
  };

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}