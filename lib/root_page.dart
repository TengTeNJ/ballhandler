import 'dart:math';
import 'package:code/constants/constants.dart';
import 'package:code/controllers/airbattle/airbattle_home_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/profile/profile_controller.dart';
import 'package:code/controllers/ranking/ranking_controller.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/event_track.dart';
import 'package:code/utils/global.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/system_device.dart';
import 'package:code/utils/video_util.dart';
import 'package:code/widgets/navigation/customBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
class RootPageController extends StatefulWidget {
  const RootPageController({super.key});

  @override
  State<RootPageController> createState() => _RootPageControllerState();
}

class _RootPageControllerState extends State<RootPageController> {
  int _currentIndex = 0;
  late PageController _pageController;
  final List<StatefulWidget> _pageViews = [
    HomePageController(),
    AirBattleHomeController(),
    RankingController(),
    ProfileController(),
  ];

  // int generateBinaryNumber(int length) {
  //   Random random = Random();
  //   int result = 0;
  //   print('random=${random}');
  //   for (int i = 0; i < length; i++) {
  //     result <<= 1; // 左移一位
  //     //result |= random.nextInt(2); // 使用随机数设置当前位
  //   }
  //   result |= 5;
  //   return result;
  // }

  @override
  void initState() {
    super.initState();
    // 设置埋点通用参数
    EventTrackUtil.setDefaultParameters();
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
    fireBaseMessage();
  }

  /*刷新token删除本地的存储的视频*/
  refreshTokenAndDeleteLocanVideo() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken:\n${fcmToken}');
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.firebaseToken = fcmToken ?? '';
    final _datas =
        await DatabaseHelper().getVideoListData(kDataBaseTVideoableName);
    if (_datas != null && _datas.length > 0) {
      VideoUtil().deleteFileInBackground(_datas);
    }
  }

  fireBaseMessage() async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification?.body}");
      // 处理收到的消息，例如显示通知
     //FlutterAppBadger.updateBadgeCount(2);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened: ${message.notification?.body}");
      // 处理用户点击通知消息打开应用的事件
    });
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
    super.dispose();
  }
}
