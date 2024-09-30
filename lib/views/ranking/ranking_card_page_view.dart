import 'package:code/views/ranking/ranking_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/http/participants.dart';
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
    // List<GameScene> array = [GameScene.five,GameScene.erqiling,GameScene.threee];
    SceneModel _matchModel = gameUtil.sceneList.firstWhere(
        (element) =>
            (int.parse(element.dictKey) - 1) == gameUtil.gameScene.index,
        orElse: null);
    if (_matchModel != null) {
      int index = gameUtil.sceneList.indexOf(_matchModel);
      _pageController = PageController(initialPage: index)
        ..addListener(() {
          int currentpage = _pageController.page!.round();
          widget.onChange(currentpage);
        });
    } else {
      _pageController = PageController(initialPage: 0)
        ..addListener(() {
          int currentpage = _pageController.page!.round();
          widget.onChange(currentpage);
        });
    }

    Future.delayed(Duration(milliseconds: 100), () {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      // List<GameScene> array = [GameScene.five,GameScene.erqiling,GameScene.threee];
      SceneModel _matchModel = gameUtil.sceneList.firstWhere(
          (element) =>
              (int.parse(element.dictKey) - 1) == gameUtil.gameScene.index,
          orElse: null);
      int index = 0;
      if (_matchModel != null) {
        index = gameUtil.sceneList.indexOf(_matchModel);
      }
      _pageController.jumpToPage(index);
      widget.onChange(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    return PageView.builder(
      itemBuilder: (context, index) {
        SceneModel sceneModel = gameUtil.sceneList[index];
        int _index = int.parse(sceneModel.dictKey) - 1;
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
          child: RankingCardView(
            index: _index,
          ),
        );
      },
      itemCount: gameUtil.sceneList.length,
      controller: _pageController,
    );
  }
}
