import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/participants/subscribe_new_border_view.dart';
import 'package:code/views/subscribe/subscribe_page_views.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:code/widgets/base/base_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../models/global/user_info.dart';
import '../../route/route.dart';
import '../../services/http/account.dart';
import '../../utils/app_purse.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../utils/notification_bloc.dart';
import '../../views/subscribe/comparison_list_view.dart';
import '../../views/subscribe/subscribe_title_view.dart';

class SubscribeController extends StatefulWidget {
  const SubscribeController({super.key});

  @override
  State<SubscribeController> createState() => _SubscribeControllerState();
}

class _SubscribeControllerState extends State<SubscribeController> {
  AppPurse purse = AppPurse();
  late StreamSubscription subscription;
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);
    Future.delayed(Duration(milliseconds: 500), () {
      // 开始监听
      purse.startSubscription(context);
    });
    //StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
    subscription = EventBus().stream.listen((event) {
      if (event == kFinishSubscribe) {
        TTToast.showSuccessInfo('Success!');
        NavigatorUtil.popToRoot();
      }
    });
  }

  /*查询订阅信息 */
  querySubScribeInfo(BuildContext buildContext) async {
    final _response = await Account.querySubscribeInfo();
    if (_response.success) {
      var model = _response.data;
      if (model != null) {
        if (mounted) {
          UserProvider.of(buildContext).subscribeModel = model;
          TTToast.showSuccessInfo('Success!');
          // Future.delayed(Duration(milliseconds: 2000),(){
          //   NavigatorUtil.pop();
          // });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              child:  [topWidget(context),bottomWidget(context)][index],
            );
          }),
    );
  }

  Widget topWidget(BuildContext context){
    return Stack(
      children: [
        Positioned(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('images/launch/subscribe_background1.png'),
                  fit: BoxFit.fill,
                ),
              ),
            )),
        Positioned(
          child:  CancelButton(),
          top: 48,
          right: 16,
        ),
        Positioned(
            top: Constants.screenHeight(context) * 0.114 + 16,
            left: 16,
            right: 16,
            child: Container(
              width: Constants.screenWidth(context) - 64,
              child: Constants.boldWhiteTextWidget('Membership Options', 30,
                  textAlign: TextAlign.center),
              // color: Colors.red,
            )),
        Positioned(
            left: 0,
            right: 0,
            top: Constants.screenHeight(context) * 0.24,
            bottom: Constants.screenHeight(context) * 0.45,
            child: SubscribePageViews()),
        Positioned(
            left: 24,
            right: 24,
            top: Constants.screenHeight(context) * 0.59,
            child: SubscribeNewBorderView(
              leftTitle: 'Annual',
              des: '-17%',
              rightTitle: '\$89.99',
              onTap: () async {
                // 点击购买年度订阅
                TTToast.showLoading();
                final ProductDetailsResponse yearResponse =
                await InAppPurchase.instance
                    .queryProductDetails(kYearProductIds);
                if (yearResponse.productDetails.isNotEmpty) {
                  // 开始购买
                  GameUtil gameUtil = GetIt.instance<GameUtil>();
                  gameUtil.notClickSubscribeDialog = false;
                  TTToast.hideLoading();
                  purse.begainBuy(yearResponse.productDetails.first);
                }
              },
            )),
        Positioned(
            left: 24,
            right: 24,
            top: Constants.screenHeight(context) * 0.59 + 88,
            child: SubscribeNewBorderView(
              leftTitle: 'Monthly',
              unitText: '/mo',
              rightTitle: '\$8.99',
              onTap: () async {
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
            )),
        Positioned(
            left: 44,
            right: 44,
            top: Constants.screenHeight(context) * 0.59 + 88 + 64 + 12,
            child: Constants.regularWhiteTextWidget(
                'Recurring billing. Cancel anytime.',
                14,
                height: 1.3)),
        Positioned(
          left: 16,
          right: 16,
          top: Constants.screenHeight(context) * 0.59 + 88 + 64 + 12 + 16 + 34,
          child:Column(
            children: [
              BaseButton(title: 'Subscribe Now'),
              SizedBox(height: 28,),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('images/subscribe/bottom.png'),height: 10,),
                    SizedBox(width: 6,),
                    Constants.regularWhiteTextWidget('Subscription Terms', 14),
                  ],
                ),
                onTap: (){
                  _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget bottomWidget(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 48,),
        GestureDetector(
          onTap: (){
            _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/subscribe/top.png'),height: 10,),
              SizedBox(width: 6,),
              Constants.regularWhiteTextWidget('Subscription Terms', 14),
            ],
          ),
        ),
        SizedBox(height: 32,),
        // Padding(padding: EdgeInsets.only(right: 16),child: Row(
         //   mainAxisAlignment: MainAxisAlignment.end,
         //   children: [
         //     CancelButton()
         //   ],
         // ),),
         Constants.boldWhiteTextWidget('What You Get', 20),
        SizedBox(height: 18,),
        SubscribeTitleView(),
        SizedBox(height: 14,),
        Container(
          height:7 * 52,
          child: ComparisonListView() ,
        ),
        SizedBox(height: 60,),
        Padding(padding: EdgeInsets.only(left: 44,right: 44),child: Constants.regularWhiteTextWidget(
            'The Ultimate training companion for your Ultimater Dangler 2.0 and more',
            14,
            height: 1.3),),
        SizedBox(height: 24,),
        Padding(padding: EdgeInsets.only(left: 16,right: 16),child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.push(Routes.webview,
                    arguments: kTermsOfServiceUrl);
              },
              child: Constants.mediumBaseTextWidget('Terms of Service', 12),
            ),
            Container(
              width: 1,
              height: 12,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6)),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.push(Routes.webview,
                    arguments: kPrivacyPolicyUrl);
              },
              child:
              Constants.mediumBaseTextWidget('Privacy Statement', 12),
            ),
            Container(
              width: 1,
              height: 12,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6)),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                purse.restorePurchase();
              },
              child: Constants.mediumBaseTextWidget('Restore Purchase', 12),
            )
          ],
        ),)
      ],
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    StatusBarControl.setHidden(false, animation: StatusBarAnimation.SLIDE);
    subscription.cancel();
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.notClickSubscribeDialog = true;
    super.dispose();
  }
}
