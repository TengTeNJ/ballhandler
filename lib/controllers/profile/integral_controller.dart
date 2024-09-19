import 'dart:async';

import 'package:code/constants/constants.dart';
import 'package:code/controllers/profile/Integral_detail_controller.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/profile/exchange_rewards_list_view.dart';
import 'package:code/views/profile/integral_next_view.dart';
import 'package:code/widgets/account/cancel_button.dart';
import 'package:flutter/material.dart';

import '../../services/http/profile.dart';
import '../../utils/notification_bloc.dart';

class IntegralController extends StatefulWidget {
  MyAccountDataModel model;

  IntegralController({required this.model});

  @override
  State<IntegralController> createState() => _IntegralControllerState();
}

class _IntegralControllerState extends State<IntegralController> {

  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) async{
    if(event == kIntegralChange){
      final _response =  await Profile.queryIMyIntegralData();
      if(_response.success){
       widget.model.integral = _response.data ?? 0;
       if(mounted){
         setState(() {
         });
       }
      }
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 36,
              margin: EdgeInsets.only(top: 24),
              child: Stack(
                children: [
                  Positioned(right: 16, child: CancelButton()),
                  Center(
                    child: Constants.boldWhiteTextWidget('Your Rewards Progress', 20),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              margin: EdgeInsets.only(left: 16,right: 16),
              color: hexStringToColor('#565674'),
              height: 0.5,
            ),
            SizedBox(
              height: 26,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Constants.boldBaseTextWidget(
                    widget.model.integral.toString(), 40),
                SizedBox(
                  height: 8,
                ),
                Constants.regularGreyTextWidget('Pucks', 14),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    // NavigatorUtil.present(IntegralDetailController());
                    NavigatorUtil.push('integralDetail');
                  },
                  child: Container(
                    width: 106,
                    height: 26,
                    decoration: BoxDecoration(
                      color: hexStringToColor('#292936'),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Padding(padding: EdgeInsets.only(left: 8,right: 8),child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Constants.regularBaseTextWidget('Pucks History', 12),
                          SizedBox(
                            width: 8,
                          ),
                          Image(
                            image: AssetImage('images/profile/back.png'),
                            width: 5,
                            height: 10,
                          )
                        ],
                      ),),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 36,
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: IntegralNextView(
                model: widget.model,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: Constants.mediumWhiteTextWidget('Exchange Rewards', 16,
                  textAlign: TextAlign.left),
              width: Constants.screenWidth(context) - 32,
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(child: ExchangeRewardListView())
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Constants.darkControllerColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }
}
