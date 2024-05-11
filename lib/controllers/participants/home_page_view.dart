import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/services/http/participants.dart';
import 'package:code/services/sqlite/data_base.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/notification_bloc.dart';
import 'package:code/utils/nsuserdefault_util.dart';
import 'package:code/views/participants/home_body_view.dart';
import 'package:code/views/participants/overall_data_view.dart';
import 'package:code/views/participants/user_info_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../route/route.dart';
import '../../utils/event_track.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageController> {
  int _currentIndex = 0;
  late final initialPage;

  late PageController _pageController;
  late StreamSubscription subscription;
   List<Widget> _pageViews = [];

  // 获取用户首页的数据
  getHomeData(BuildContext context) async {
    // 登录了则请求相关数据
    final _token = await NSUserDefault.getValue(kAccessToken);
    if (_token != null && _token.length > 0) {
      Participants.getHomeUserData().then((value) {
        if (value.success && value.data != null) {
          UserProvider.of(context).avgPace = value.data!.avgPace;
          UserProvider.of(context).totalTimes = value.data!.trainCount;
          UserProvider.of(context).totalScore = value.data!.trainScore;
          UserProvider.of(context).totalTime = value.data!.trainTime;
          // 首页弹窗
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if (value.data!.noticeType != 0) {
            if (!gameUtil.hasShowNitice) {
              TTDialog.championDialog(context, () {
                NavigatorUtil.push(Routes.awardlist); // 跳转到获奖列表页面
              });
              gameUtil.hasShowNitice = true;
            }
          }
        }
      });
    } else {
      DatabaseHelper().getLocalGuestData(context);
    }
  }

  @override
  void initState() {
    super.initState();
    GameUtil gameUtil = GetIt.instance<GameUtil>();
   // 初始化pageview试图数组
    gameUtil.sceneList.forEach((element) {
      _pageViews.add(HomeBodyView(model: element));
    });

    // 初始化pageView
    _currentIndex = gameUtil.gameScene.index;
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if (_currentIndex != currentpage) {
        print('_currentIndex= ${_currentIndex} currentpage = ${currentpage}');
        setState(() {
          _currentIndex = currentpage;
          gameUtil.gameScene = [
            GameScene.five,
            GameScene.erqiling,
            GameScene.threee
          ][_currentIndex];
        });
        // 延迟100毫秒进行数据请求，防止初始化本地用户信息未完成
        Future.delayed(Duration(milliseconds: 100), () {
         getHomeData(context);
        });
      }
    });
    // 监听
    subscription = EventBus().stream.listen((event) {
      if (event == kLoginSucess || event == kFinishGame || event == kSignOut) {
        // 登录成功,完成游戏
        getHomeData(context);
        if(event == kLoginSucess){
          // 设置埋点通用参数
          EventTrackUtil.setDefaultParameters();
        }
      }
    });
    Future.delayed(Duration(milliseconds: 100), () {
      getHomeData(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
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
                  itemCount: gameUtil.sceneList.length,
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
                      count: gameUtil.sceneList.length,
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
