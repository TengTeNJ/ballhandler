import 'dart:async';
import 'package:code/constants/constants.dart';
import 'package:code/controllers/account/set_email_controller.dart';
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
import '../../models/http/subscribe_model.dart';
import '../../route/route.dart';
import '../../services/http/account.dart';
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
  bool haslogin = false;
  late PageController _pageController;
  late StreamSubscription subscription;
  List<Widget> _pageViews = [];
  bool isLaunch = true;

  // 获取用户首页的数据
  getHomeData(BuildContext context) async {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    // 登录了则请求相关数据
    if(isLaunch){
      int? value = await NSUserDefault.getValue<int>(kSceneSelectCache);
      if(value != null){
        List<GameScene> array = [GameScene.five,GameScene.erqiling,GameScene.threee];
        gameUtil.gameScene = array[value];
      }
      isLaunch = false;
    }
    final _token = await NSUserDefault.getValue(kAccessToken);
    if (_token != null && _token.length > 0) {
      haslogin = true;
      Participants.getHomeUserData().then((value) {
        if (value.success && value.data != null) {
          if(!mounted){
            return;
          }
          UserProvider.of(context).avgPace = value.data!.avgPace;
          UserProvider.of(context).totalTimes = value.data!.trainCount;
          UserProvider.of(context).totalScore = value.data!.trainScore;
          UserProvider.of(context).totalTime = value.data!.trainTime;
          // 首页弹窗
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
      // 请求订阅数据
     querySubScribeInfo();
    } else {
      // 未登录状态
      haslogin = false;
      DatabaseHelper().getLocalGuestData(context);
    }
  }

  /*查询订阅信息 */
  querySubScribeInfo() async{
    final _response = await Account.querySubscribeInfo();
    if(_response.success){
      SubscribeModel? model = _response.data;
      if(model != null){
        UserProvider.of(context).subscribeModel = model;
      }
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
   // _currentIndex = gameUtil.gameScene.index;
    SceneModel _matchModel = gameUtil.sceneList.firstWhere((element)=>(int.parse(element.dictKey) - 1) == gameUtil.gameScene.index,orElse: null);
    if(_matchModel != null){
      int index = gameUtil.sceneList.indexOf(_matchModel);
      _currentIndex = index;
    }
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if (_currentIndex != currentpage) {
        print('_currentIndex= ${_currentIndex} currentpage = ${currentpage}');
        setState(() {
          _currentIndex = currentpage;
          SceneModel model = gameUtil.sceneList[_currentIndex];
          int value = int.parse(model.dictKey) - 1;
          gameUtil.gameScene = [
            GameScene.five,
            GameScene.erqiling,
            GameScene.threee
          ][value];
        });
        // 延迟100毫秒进行数据请求，防止初始化本地用户信息未完成
        Future.delayed(Duration(milliseconds: 100), () {
         getHomeData(context);
        });
      }
    });
    // 监听
    subscription = EventBus().stream.listen((event) async{
      if (event == kLoginSucess || event == kFinishGame || event == kSignOut) {
        // 登录成功,完成游戏
        getHomeData(context);
        if(event == kLoginSucess){
          // 设置埋点通用参数
         // EventTrackUtil.setDefaultParameters();
          querySceneListdata(); // 防止初次安装用户未选择网络
          final _email =  UserProvider.of(context).email;
          if(ISEmpty(_email)){
            // 如果邮箱为空，则提示用户去绑定
            NavigatorUtil.present(SetEmailController());
          }
        }
      }else if(event == kPopSubscribeDialog){
        // 订阅弹窗
        NavigatorUtil.push(Routes.subscribeintroduce);
       // TTDialog.subscribeDialog(context);
        // 防止首次调用poproroot后把设置邮箱的弹窗dismiss
        final _email =  UserProvider.of(context).email;
        if(ISEmpty(_email)){
          // 如果邮箱为空，则提示用户去绑定
          NavigatorUtil.present(SetEmailController());
        }
      }else if(event == kPopSubscribeLate){
        // 防止首次调用poproroot后把设置邮箱的弹窗dismiss
        final _email =  UserProvider.of(context).email;
        if(ISEmpty(_email)){
          // 如果邮箱为空，则提示用户去绑定
          NavigatorUtil.present(SetEmailController());
        }
      }
    });

    Future.delayed(Duration(milliseconds: 100), () {
      getHomeData(context);
    });
    // 查询场景列表
    querySceneListdata();
  }
  /*查询场景列表数据*/
  Future<void> querySceneListdata() async {
    final _response = await Participants.querySceneListData();
    if (_response.success && _response.data != null) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.sceneList.clear();
      gameUtil.sceneList.addAll(_response.data!);
      _pageViews.clear();
      gameUtil.sceneList.forEach((element) {
        _pageViews.add(HomeBodyView(model: element));
      });
      int? value = await NSUserDefault.getValue<int>(kSceneSelectCache);
      print('value == ${value}');
      List<GameScene> array = [GameScene.five,GameScene.erqiling,GameScene.threee];
      if(value!=null && _pageViews.length > value){
        // 获取场景缓存
        gameUtil.gameScene = array[value];
       SceneModel _matchModel = gameUtil.sceneList.firstWhere((element)=>(int.parse(element.dictKey) - 1) == array[value].index,orElse: null);
       if(_matchModel != null){
         int index = gameUtil.sceneList.indexOf(_matchModel);
         _pageController.jumpToPage(index);
         _currentIndex = index;
       }
      }
      if(mounted){
        setState(() {

        });
      }

    }
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
              child: UserInfoView(
                hasLogin: haslogin,
                subscribeTap: (){
                  NavigatorUtil.push(Routes.subscribe);
                  //TTDialog.subscribeDialog(context);
                },
              ),
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
                    child: gameUtil.sceneList.length > 1 ? IndicatorView(
                      count: gameUtil.sceneList.length,
                      currentPage: _currentIndex,
                      defaultColor: Color.fromRGBO(204, 204, 204, 1.0),
                      currentPageColor: Constants.baseStyleColor,
                    ):Container(),
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
