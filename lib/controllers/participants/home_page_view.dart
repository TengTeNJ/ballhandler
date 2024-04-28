import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/views/participants/home_body_view.dart';
import 'package:code/views/participants/overall_data_view.dart';
import 'package:code/views/participants/user_info_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../utils/global.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageController> {
  int _currentIndex = 0;
  late  final initialPage ;
 late PageController _pageController;
  late StreamSubscription subscription;
  final List<Widget> _pageViews = [
    HomeBodyView(),
    HomeBodyView(),
    HomeBodyView()
  ];

  // 获取用户首页的数据
  getHomeData(BuildContext context) {
    Participants.getHomeUserData().then((value) {
      if (value.success) {
        UserProvider.of(context).avgPace = value.data!.avgPace;
        UserProvider.of(context).totalTimes = value.data!.trainCount;
        UserProvider.of(context).totalScore = value.data!.trainScore;
        UserProvider.of(context).totalTime = value.data!.trainTime;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    _currentIndex = gameUtil.gameScene.index;
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if (_currentIndex != currentpage) {
        setState(() {
          _currentIndex = currentpage;
          gameUtil.gameScene = [
            GameScene.five,
            GameScene.erqiling,
            GameScene.threee
          ][_currentIndex];
        });
        getHomeData(context);
      }
    });
    // 监听登录成功
    subscription = EventBus().stream.listen((event) {
      if (event == kLoginSucess) {
        getHomeData(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getHomeData(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.baseControllerColor,
      appBar: CustomAppBar(
        title: '',
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.darkThemeColor, Constants.baseControllerColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        margin: EdgeInsets.only(left: 0, right: 0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: UserInfoView(),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: OverAllDataView(),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: _pageViews[index],
                    );
                  }),
            ),
            Container(
              height: 34,
              child: Column(
                children: [
                  Container(
                    height: 30,
                    child: IndicatorView(
                      count: 3,
                      currentPage: _currentIndex,
                      defaultColor: Color.fromRGBO(204, 204, 204, 1.0),
                      currentPageColor: Constants.baseStyleColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // 在不需要监听事件时取消订阅
    subscription.cancel();
    super.dispose();
  }
}
