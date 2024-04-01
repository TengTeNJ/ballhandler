// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/account/send_email_controller.dart';
import 'package:code/controllers/airbattle/activity_detail_controller.dart';
import 'package:code/controllers/airbattle/message_controller.dart';
import 'package:code/controllers/participants/TodayDataController.dart';
import 'package:code/controllers/participants/game_finish_controller.dart';
import 'package:code/controllers/participants/game_video_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/participants/training_mode_controller.dart';
import 'package:code/controllers/participants/video_check_controller.dart';
import 'package:code/controllers/participants/video_play_controller.dart';
import 'package:code/controllers/profile/Integral_detail_controller.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class Routes {
  static const String home = '/'; // 主页
  static const String login = 'login'; // 登录界面
  static const String privacy = 'privacy';
  static const String sendemial = 'sendEmial'; //  活动详情页面
  static const String trainingMode = 'trainingMode'; // 训练模式选择
  static const String videocheck = 'videoCheck'; // 视频校验页面
  static const String gamevideo = 'gameVideo'; //  游戏界面，选择视频录制
  static const String gamefinish = 'gameFinish'; //  游戏完成界面，选择视频录制
  static const String videoplay = 'videoPlay'; //  视频播放页面
  static const String todaydata = 'todayData'; //  视频播放页面
  static const String message = 'message'; //  消息页面
  static const String actividydetail = 'activityDetail'; //  活动详情页面
  static const String integraldetail = 'integralDetail'; //  活动详情页面
  //GameFinishController VideoPlayController
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
      case gamefinish:{
        final  GameOverModel model = settings.arguments as GameOverModel;
        return MaterialPageRoute(builder: (_)=> GameFinishController(dataModel: model,));
      }
      case videoplay:{
        final  String path = settings.arguments as String;
        print('----path---${path}');
        return MaterialPageRoute(builder: (_)=> VideoPlayController(videoPath: path,));
      }
      case todaydata:
        return MaterialPageRoute(builder: (_) => TodayDataController());
      case message:
        return MaterialPageRoute(builder: (_) => MessageController());
      case actividydetail:
        return MaterialPageRoute(builder: (_) => ActivityDetailController());
      case sendemial:
        return MaterialPageRoute(builder: (_) => SendEmailController());
      case integraldetail:
        return MaterialPageRoute(builder: (_) => IntegralDetailController());
      default:
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