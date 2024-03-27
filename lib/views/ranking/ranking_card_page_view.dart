import 'package:code/views/ranking/ranking_card_view.dart';
import 'package:flutter/material.dart';
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
    _pageController = PageController()
    ..addListener(() {
      int currentpage = _pageController.page!.round();
      widget.onChange(currentpage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(itemBuilder: (context,index){
      return Padding(padding: EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 10),child: RankingCardView(),);
    },itemCount: 3,controller: _pageController,);
  }
}
