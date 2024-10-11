import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/services/http/rank.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/base/no_data_view.dart';
import 'package:code/views/ranking/ranking_card_page_view.dart';
import 'package:code/views/ranking/ranking_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../models/global/user_info.dart';
import '../../services/http/participants.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import '../../utils/nsuserdefault_util.dart';

class RankingController extends StatefulWidget {
  const RankingController({super.key});

  @override
  State<RankingController> createState() => _RankingControllerState();
}

class _RankingControllerState extends State<RankingController> {
  List<RankModel> _datas = [];
  int _currentPageIndex = 0;
  int _page = 1;
  bool _hasMode = false;

  // 卡片页滑动监听
  void _pageViewOnChange(int index) {
    print('index = ${index}');
    if(index == _currentPageIndex){
      return;
    }
    setState(() {
      _page = 1;
      _datas.clear();
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      SceneModel model = gameUtil.sceneList[index];
      int value = int.parse(model.dictKey) - 1;
      gameUtil.gameScene = [
        GameScene.five,
        GameScene.erqiling,
        GameScene.threee
      ][value];
      // 放入缓存
      NSUserDefault.setKeyValue<int>(
          kSceneSelectCache, gameUtil.gameScene.index);
      _currentPageIndex = index;
    });
    queryRankList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryRankList();
  }
  /* 获取排行榜数据*/
  queryRankList({bool loadMore = false}) async{
    if(loadMore){
      TTToast.showLoading();
    }
    final _response = await Rank.queryRankListData(_page);
    if(_response.success && _response.data != null){
      if(!loadMore){
        _datas.clear();
      }
     _datas.addAll(_response.data!.data);
     _hasMode = (_datas.length < _response.data!.count);
     setState(() {

     });
    }
    if(loadMore){
      TTToast.hideLoading();
    }
  }
  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      appBar: CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.darkThemeColor, Constants.baseControllerColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Constants.boldWhiteTextWidget('Leaderboards', 30),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(onTap: (){
              // 跳转到数据分析页面
              if(UserProvider.of(context).subscribeModel.subscribeStatus != 1){
                // 未订阅 则限制进入
                NavigatorUtil.push(Routes.subscribeintroduce);
                // TTDialog.subscribeDialog(context);
                return;
              }
              NavigatorUtil.push(Routes.mystats);
            },child: Container(
              width: Constants.screenWidth(context),
              height: 156,
              // color: Colors.orange,
              child: RankingCardPageView(onChange: _pageViewOnChange),
            ),),
            gameUtil.sceneList.length > 1 ? IndicatorView(
              count: gameUtil.sceneList.length,
              currentPage: _currentPageIndex,
              currentPageColor: Constants.baseStyleColor,
            ) :Container(),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Constants.mediumWhiteTextWidget('Training Rank', 16),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: _datas.length > 0 ? RankingListView(datas: _datas,loadMore: (){
                // 上拉加载
                if(_hasMode){
                  _page ++;
                  queryRankList(loadMore: true);
                }
              },): NoDataView(),
            )),
          ],
        ),
      ),
    );
  }
}
