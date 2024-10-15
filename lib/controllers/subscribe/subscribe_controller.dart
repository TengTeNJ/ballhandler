import 'package:code/constants/constants.dart';
import 'package:code/utils/toast.dart';
import 'package:code/views/participants/subscribe_new_border_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../route/route.dart';
import '../../utils/app_purse.dart';
import '../../utils/navigator_util.dart';

class SubscribeController extends StatefulWidget {
  const SubscribeController({super.key});

  @override
  State<SubscribeController> createState() => _SubscribeControllerState();
}

class _SubscribeControllerState extends State<SubscribeController> {
  AppPurse purse = AppPurse();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      // 开始监听
      purse.startSubscription(context);
    });
    StatusBarControl.setHidden(true, animation: StatusBarAnimation.SLIDE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.baseControllerColor,
      body: Stack(
        children: [
          Positioned(
              child: Container(
            decoration: BoxDecoration(
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('images/launch/subscribe_background.png'),
                fit: BoxFit.fill,
              ),
            ),
          )),
          Positioned(
            child: CancelButton(),
            top: 32,
            right: 16,
          ),
          Positioned(
              top: Constants.screenHeight(context) * 0.48,
              left: 32,
              right: 32,
              child: Container(
                width: Constants.screenWidth(context) - 64,
                child: Constants.boldWhiteTextWidget('Membership Options', 30,
                    textAlign: TextAlign.center),
                // color: Colors.red,
              )),
          Positioned(
              left: 24,
              right: 24,
              top: Constants.screenHeight(context) * 0.59,
              child: SubscribeNewBorderView(
                leftTitle: 'Annual',
                des: '-30%',
                rightTitle: '\$179.99',
                onTap: () async {
                  // 点击购买年度订阅
                  TTToast.showLoading();
                  final ProductDetailsResponse yearResponse =
                      await InAppPurchase.instance
                          .queryProductDetails(kYearProductIds);
                  if (yearResponse.productDetails.isNotEmpty) {
                    // 开始购买
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
                rightTitle: '\$17.99',
                onTap: () async {
                  // 点击月度订阅
                  TTToast.showLoading();
                  final ProductDetailsResponse yearResponse =
                      await InAppPurchase.instance
                          .queryProductDetails(kMonthProductIds);
                  if (yearResponse.productDetails.isNotEmpty) {
                    // 开始购买
                    TTToast.hideLoading();
                    purse.begainBuy(yearResponse.productDetails.first);
                  }
                },
              )),
          Positioned(
              left: 44,
              right: 44,
              top: Constants.screenHeight(context) * 0.59 + 88 + 99,
              child: Constants.regularWhiteTextWidget(
                  'The Ultimate training companion for your Ultimater Dangler 2.0 and more',
                  14,
                  height: 1.3)),
          Positioned(
            left: 54,
            right: 54,
            top: Constants.screenHeight(context) * 0.59 + 88 + 99 + 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.push(Routes.webview);
                  },
                  child: Constants.mediumBaseTextWidget('Terms of Service', 14),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.push(Routes.webview,
                        arguments:
                            'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                  },
                  child:
                      Constants.mediumBaseTextWidget('Privacy Statement', 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    StatusBarControl.setHidden(false, animation: StatusBarAnimation.SLIDE);
    super.dispose();
  }
}
