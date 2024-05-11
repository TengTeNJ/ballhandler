// routes.dart
import 'package:code/controllers/account/login_page_controller.dart';
import 'package:code/controllers/account/privacy_page_controller.dart';
import 'package:code/controllers/account/send_email_controller.dart';
import 'package:code/controllers/airbattle/activity_detail_controller.dart';
import 'package:code/controllers/airbattle/award_list_controller.dart';
import 'package:code/controllers/airbattle/message_controller.dart';
import 'package:code/controllers/airbattle/my_activity_controller.dart';
import 'package:code/controllers/participants/TodayDataController.dart';
import 'package:code/controllers/participants/game_finish_controller.dart';
import 'package:code/controllers/participants/game_process_controller.dart';
import 'package:code/controllers/participants/game_video_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/participants/p1_controller.dart';
import 'package:code/controllers/participants/p3_game_process_controller.dart';
import 'package:code/controllers/participants/p3_record_select_controller.dart';
import 'package:code/controllers/participants/record_select_controller.dart';
import 'package:code/controllers/participants/training_mode_controller.dart';
import 'package:code/controllers/participants/video_check_controller.dart';
import 'package:code/controllers/participants/video_list_controller.dart';
import 'package:code/controllers/participants/video_play_controller.dart';
import 'package:code/controllers/profile/Integral_detail_controller.dart';
import 'package:code/controllers/profile/setting_controller.dart';
import 'package:code/controllers/profile/sub_setting_controller.dart';
import 'package:code/controllers/ranking/my_stats_controller.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/airbattle.dart';
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
  static const String gameprocess = 'gameProcess'; //  游戏界面
  static const String myactivity = 'myActivity'; // 我的活动页面
  static const String mystats = 'myStats'; // 数据分析页面
  static const String awardlist = 'awardList'; // 获奖列表页面
  static const String setting = 'setting'; // 设置页面
  static const String recordselect = 'recordSelect'; // record选择页面
  static const String subsetting = 'subSetting'; // 二级设置页面
  static const String p1 = 'p1'; // 270度的P1模式介绍页面
  static const String p3check = 'p3Check';
  static const String process270 = '270Process';
  static const String videolist = 'videoList'; // 视频列表页面

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
      case gameprocess:{
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_)=> GameProcessController(camera: camera,));
      }
      case videoplay:{
        final  Map _map = settings.arguments as Map;
        return MaterialPageRoute(builder: (_)=> VideoPlayController(model: _map['model'], fromGameFinishPage: _map['gameFinish'],));
      }
      case todaydata:
        return MaterialPageRoute(builder: (_) => TodayDataController());
      case message:
        return MaterialPageRoute(builder: (_) => MessageController());
      case actividydetail:
        final  ActivityModel model = settings.arguments as ActivityModel;
        return MaterialPageRoute(builder: (_) => ActivityDetailController(model: model,));
      case sendemial:
        return MaterialPageRoute(builder: (_) => SendEmailController());
      case integraldetail:
        return MaterialPageRoute(builder: (_) => IntegralDetailController());
      case myactivity:
        return MaterialPageRoute(builder: (_) => MyActivityController());
      case mystats:
        return MaterialPageRoute(builder: (_) => MyStatsController());
      case awardlist:
        return MaterialPageRoute(builder: (_) => AwardListController());
      case setting:
        print('------------------');
        return MaterialPageRoute(builder: (_) => SettingController());
      case recordselect:
        return MaterialPageRoute(builder: (_) => RecordSelectController());
      case subsetting:{
        final  Map _map = settings.arguments as Map;
        print('_map=${_map}');
        return MaterialPageRoute(builder: (_)=> SubSettingController(title: _map['title'] ?? '',subTitle: _map['subTitle'] ,switchCount: _map['switchCount'] ?? 1,));
      }
      case p1:
        return MaterialPageRoute(builder: (_) => P1Controller());
      case p3check:{
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_)=> P3RecordSelectController(camera: camera,));
      }
      case process270:{
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_)=> P3GameProcesController(camera: camera,));
      }
      case videolist:
        return MaterialPageRoute(builder: (_) => VideoListController());
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