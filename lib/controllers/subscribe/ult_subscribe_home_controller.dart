import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/subscribe/subscribe_five_page_view.dart';
import 'package:code/views/subscribe/subscribe_four_page_view.dart';
import 'package:code/views/subscribe/subscribe_one_page_view.dart';
import 'package:code/views/subscribe/subscribe_six_page_view.dart';
import 'package:code/views/subscribe/subscribe_three_page_view.dart';
import 'package:code/views/subscribe/subscribe_two_page_view.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../utils/nsuserdefault_util.dart';

class UltSubscribeHomeController extends StatefulWidget {
  const UltSubscribeHomeController({super.key});

  @override
  State<UltSubscribeHomeController> createState() =>
      _UltSubscribeHomeControllerState();
}

class _UltSubscribeHomeControllerState
    extends State<UltSubscribeHomeController> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<Widget> _views = [
    SubscribeOnePageView(),
    SubscribeTwoPageView(),
    SubscribeThreePageView(),
    SubscribeFourPageView(),
    SubscribeFivePageView(),
    SubscribeSixPageView()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _pageController.addListener(() {
      // 获取当前滑动页面的索引 (取整)
      int currentpage = _pageController.page!.round();
      if(currentpage == _views.length - 1){
        WidgetsBinding.instance.addPostFrameCallback((timeStamp){
          NSUserDefault.setKeyValue(kShowLaunch, "done");
        });
      }
      if (_currentIndex != currentpage) {
        setState(() {
          _currentIndex = currentpage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              bottom: Constants.screenHeight(context) * 0.28,
              top: Constants.screenHeight(context) * 0.14,
              child: PageView.builder(
                 itemCount:_views.length ,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return _views[index];
                  })),
          Positioned(
            child: Container(
                child: IndicatorView(
                  currentPage: _currentIndex,
                  count: 6,
                  horizontal: 8,
                  currentPageColor: Constants.baseStyleColor,
                ),
                height: 6),
            left: 16,
            right: 16,
            bottom: Constants.screenHeight(context) * 0.21,
          ),
          _currentIndex == _views.length-1  ? Positioned(
              child: BaseButton(
                title: 'Subscribe Now',
                onTap: () {
                  NavigatorUtil.popAndThenPush(Routes.subscribe);
                },
              ),
              left: 24,
              right: 24,
              bottom: 90) : Container(),
          _currentIndex == _views.length-1 ? Positioned(
              bottom: 48,
              left: 32,
              right: 32,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigatorUtil.pop();
                },
                child: Constants.mediumGreyTextWidget('Maybe Later', 16),
              )) : Container()
        ],
      ),
    );
  }
}
