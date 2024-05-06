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

import '../../utils/global.dart';

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

  void _pageViewOnChange(int index) {
    setState(() {
      _page = 1;
      _datas.clear();
      _currentPageIndex = index;
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      gameUtil.gameScene = [
        GameScene.five,
        GameScene.erqiling,
        GameScene.threee
      ][_currentPageIndex];
    });
    queryRankList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  /* 获取排行榜数据*/
  queryRankList({bool loadMore = false}) async{
    if(loadMore){
      TTToast.showLoading();
    }else{
      _datas.clear();
    }
    final _response = await Rank.queryRankListData(_page);
    if(_response.success && _response.data != null){
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
      backgroundColor: Constants.darkThemeColor,
      appBar: CustomAppBar(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Constants.boldWhiteTextWidget('Rankings', 30),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(onTap: (){
              // 跳转到数据分析页面
              NavigatorUtil.push(Routes.mystats);
            },child: Container(
              width: Constants.screenWidth(context),
              height: 152,
              child: RankingCardPageView(onChange: _pageViewOnChange),
            ),),
            IndicatorView(
              count: gameUtil.sceneList.length,
              currentPage: _currentPageIndex,
              currentPageColor: Constants.baseStyleColor,
            ),
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
