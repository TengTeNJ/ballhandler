import 'dart:async';
import 'dart:ui';
import 'package:code/constants/constants.dart';
import 'package:code/controllers/airbattle/airbattle_home_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/profile/profile_controller.dart';
import 'package:code/controllers/ranking/ranking_controller.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/account.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/app_purse.dart';
import 'package:code/utils/event_track.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/message_ytil.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/utils/system_device.dart';
import 'package:code/utils/video_util.dart';
import 'package:code/widgets/navigation/customBottomNavigationBar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sqflite/sqflite.dart';

import 'firebase_options.dart';

class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  int _currentIndex = 0;
  late PageController _pageController;
  late StreamSubscription subscription;
  final List<StatefulWidget> _pageViews = [
    HomePageController(),
    AirBattleHomeController(),
    RankingController(),
    ProfileController(),
  ];
  late StreamSubscription<dynamic> _subscription;
 AppPurse purse = AppPurse();

  @override
  void initState() {
    super.initState();
    handleAppPurse();
    SystemUtil.lockScreenDirection(); // 锁定屏幕方向
    _pageController = PageController()
      ..addListener(() {
        // 获取当前滑动页面的索引 (取整)
        int currentpage = _pageController.page!.round();
        if (_currentIndex != currentpage) {
          setState(() {
            _currentIndex = currentpage;
          });
        }
      });

    refreshTokenAndDeleteLocanVideo();
    subscription = EventBus().stream.listen((event) {
      if (event == kLoginSucess) {
        loadLaunchPage();
      }
    });
  }
  /*处理内购*/
  handleAppPurse(){
   // purse.startSubscription();
  }

  Future<FirebaseApp> initFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /*加载启动页*/
  loadLaunchPage() async {
    final _token = await NSUserDefault.getValue(kAccessToken);
    if (_token != null && _token.length > 0) {
      String? _launchFlag = await NSUserDefault.getValue<String>(kShowLaunch);
      if (_launchFlag != null && _launchFlag == 'done') {
        // 已经加载过启动页 不需要重新加载
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          NavigatorUtil.push(Routes.launch1);
        });
      }
    }
  }

  /*刷新token删除本地的存储的视频*/
  refreshTokenAndDeleteLocanVideo() async {
    await initFirebase(); // 初始化firebase
    // await  EventTrackUtil.setDefaultParameters();    // 设置埋点通用参数
    //  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true); // 启用调试模式 数据分析
    // 推送token
    final fcmToken =
        await FirebaseMessaging.instance.getToken(); // 获取token 用于推送通知
    if (!ISEmpty(fcmToken)) {
      print('fcmToken:\n${fcmToken}');
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.firebaseToken = fcmToken ?? '';
      final _accessToken = await NSUserDefault.getValue(kAccessToken);
      if (!ISEmpty(_accessToken)) {
        // 更新推送token
        Account.updateAccountInfo({"firebaseToken": gameUtil.firebaseToken});
      }
    }
    // 删除本地存储的视频
    final _datas =
        await DatabaseHelper().getVideoListData(kDataBaseTVideoableName);
    if (_datas != null && _datas.length > 0) {
      VideoUtil().deleteFileInBackground(_datas);
    }
    // 消息推送处理
    fireBaseMessage(); // 监听推送通知
   // fireBaseCrashlytics();
  }

  Future<void> querySceneListdata() async {
    final _response = await Participants.querySceneListData();
    if (_response.success && _response.data != null) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.sceneList.clear();
      gameUtil.sceneList.addAll(_response.data!);
    }
  }

  // 处理消息推送
  fireBaseMessage() async {
    MessageUtil.initMessageNadge();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.body}");
      // 处理收到的消息，例如显示通知
      // FlutterAppBadger.updateBadgeCount();
      MessageUtil.getOneMoreMessage();
      EventBus().sendEvent(kGetMessage);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened: ${message.notification?.body}");
      // 处理用户点击通知消息打开应用的事件
    });
    // 更新角标
    final _countData = await AirBattle.queryIUnreadCount();
    if (_countData != null && _countData.data != null) {
      MessageUtil.handleMessage(_countData.data!);
    }
  }

  /*异常捕获*/
  fireBaseCrashlytics() async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    String userName = await NSUserDefault.getValue(kUserName) ?? 'Unknown';
    String email = await NSUserDefault.getValue(kUserEmail) ?? 'Unknown';
    if (userName != null && userName.length > 0) {
      FirebaseCrashlytics.instance.log("userName:${userName}-email:${email}");
      FirebaseCrashlytics.instance.setCustomKey('userName', userName);
      FirebaseCrashlytics.instance.setCustomKey('email', email ?? '--');
    }
  }

  @override
  Widget build(BuildContext context) {
    NavigatorUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pageViews[_currentIndex],
      // body:  PageView.builder(
      //     physics: NeverScrollableScrollPhysics(), // 禁止手动滑动
      //     controller: _pageController,
      //     itemCount: 4,
      //     itemBuilder: (context, index) {
      //       return _pageViews[index];
      //     }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    subscription.cancel();
    super.dispose();
  }
}
