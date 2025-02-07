import 'package:code/constants/constants.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/subscribe/subscribe_five_page_view.dart';
import 'package:code/views/subscribe/subscribe_four_page_view.dart';
import 'package:code/views/subscribe/subscribe_one_page_view.dart';
import 'package:code/views/subscribe/subscribe_seven_page_view.dart';
import 'package:code/views/subscribe/subscribe_six_page_view.dart';
import 'package:code/views/subscribe/subscribe_three_page_view.dart';
import 'package:code/views/subscribe/subscribe_two_page_view.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tt_indicator/tt_indicator.dart';

import '../../utils/app_purse.dart';
import '../../utils/global.dart';
import '../../utils/nsuserdefault_util.dart';
import '../../utils/toast.dart';
import '../../widgets/account/cancel_button.dart';
import 'dart:async';

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
    SubscribeSixPageView(),
    SubscribeSevenPageView(),
  ];
  AppPurse purse = AppPurse();

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
    Future.delayed(Duration(milliseconds: 500), () {
      // 开始监听
      purse.startSubscription(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Stack(
        children: [
          Positioned(
            child: _currentIndex == _views.length - 1  ?  CancelButton() :Container(),
            top: 48,
            right: 16,
          ),
          _currentIndex == 0 ? Positioned(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('images/launch/subscribe_background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              )) : Container(),
          Positioned(
              left: 0,
              right: 0,
              bottom: Constants.screenHeight(context) * 0.2,
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
                  count: _views.length,
                  horizontal: 8,
                  currentPageColor: Constants.baseStyleColor,
                ),
                height: 6),
            left: 16,
            right: 16,
            bottom: Constants.screenHeight(context) * 0.175,
          ),
          _currentIndex == _views.length-1  ? Positioned(
              child: BaseButton(
                title: 'Sart Your Free 2 Week',
                onTap: () async {
                 // NavigatorUtil.popAndThenPush(Routes.subscribe);
                  // 点击月度订阅
                  TTToast.showLoading();
                  final ProductDetailsResponse yearResponse =
                      await InAppPurchase.instance
                      .queryProductDetails(kMonthProductIds);
                  if (yearResponse.productDetails.isNotEmpty) {
                    // 开始购买
                    GameUtil gameUtil = GetIt.instance<GameUtil>();
                    gameUtil.notClickSubscribeDialog = false;
                    TTToast.hideLoading();
                    purse.begainBuy(yearResponse.productDetails.first);
                  }
                },
              ),
              left: 24,
              right: 24,
              bottom: 80) : Container(),
          _currentIndex == _views.length-1 ? Positioned(
              bottom: 38,
              left: 32,
              right: 32,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  //NavigatorUtil.pop();
                },
                child: Constants.mediumGreyTextWidget('14 days free, then \$8.99 per month', 16),
              )) : Container()
        ],
      ),
    );
  }
}
