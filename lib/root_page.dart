import 'dart:math';
import 'package:code/constants/constants.dart';
import 'package:code/controllers/airbattle/airbattle_home_controller.dart';
import 'package:code/controllers/participants/home_page_view.dart';
import 'package:code/controllers/profile/profile_controller.dart';
import 'package:code/controllers/ranking/ranking_controller.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/video_util.dart';
import 'package:code/widgets/navigation/customBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sqflite/sqflite.dart';

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

  int generateBinaryNumber(int length) {
    Random random = Random();
    int result = 0;
    print('random=${random}');
    for (int i = 0; i < length; i++) {
      result <<= 1; // 左移一位
      //result |= random.nextInt(2); // 使用随机数设置当前位
    }
    result |= 5;
    return result;
  }

  @override
  void initState() {
    super.initState();
    // int length = 8; // 生成8位的二进制数
    // int binaryNumber = generateBinaryNumber(length);
    // print('Generated binary number: ${binaryNumber.toRadixString(2).padLeft(length, '0')}');

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

    testPush();
  }

  testPush() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken=${fcmToken}');
    final _datas =
        await DatabaseHelper().getVideoListData(kDataBaseTVideoableName);
    if (_datas != null && _datas.length > 0) {
      VideoUtil().deleteFileInBackground(_datas);
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
      // body: PageView.builder(
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
