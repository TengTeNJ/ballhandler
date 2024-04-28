import 'package:code/views/ranking/ranking_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../utils/global.dart';
class RankingCardPageView extends StatefulWidget {
  Function onChange;
  RankingCardPageView({required this.onChange});

  @override
  State<RankingCardPageView> createState() => _RankingCardPageViewState();
}

class _RankingCardPageViewState extends State<RankingCardPageView> {
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GameUtil gameUtil = GetIt.instance<GameUtil>();

    _pageController = PageController(initialPage:gameUtil.gameScene.index)
    ..addListener(() {
      int currentpage = _pageController.page!.round();
      widget.onChange(currentpage);
    });

    Future.delayed(Duration(milliseconds: 100),(){
      _pageController.jumpToPage(gameUtil.gameScene.index);
      widget.onChange(gameUtil.gameScene.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context,index){
      return Padding(padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 10),child: RankingCardView(index: index,),);
    },itemCount: 3,controller: _pageController,);
  }
}
