import 'dart:async';

import 'package:code/controllers/airbattle/airbattle_ruler_controller.dart';
import 'package:code/controllers/base/tt_webview_controller.dart';
import 'package:code/route/route.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../services/http/airbattle.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/base/base_image.dart';

class AirbattleCardView extends StatefulWidget {
  ActivityModel activityModel;

  AirbattleCardView({super.key, required this.activityModel});

  @override
  State<AirbattleCardView> createState() => _AirbattleCardViewState();
}

class _AirbattleCardViewState extends State<AirbattleCardView> {
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    //  widget.activityModel.activityStatus == 2
    // print('widget.activityModel.timeAirBattleHomeDifferentString = ${widget.activityModel.timeAirBattleHomeDifferentString}');
    return Container(
      width: Constants.screenWidth(context) - 32,
      height: (Constants.screenWidth(context) - 32) * (246 / 340),
      child: Opacity(
        opacity: widget.activityModel.activityStatus == 2 ? 0.5 : 1.0,
        child: Stack(
          children: [
            TTNetImage(
                url: '',
                // url: widget.activityModel.activityBackground,
                placeHolderPath: 'images/airbattle/under_way.png',
                width: Constants.screenWidth(context) - 32,
                height: (Constants.screenWidth(context) - 32) * (246 / 340),
                borderRadius: BorderRadius.circular(10)),
            Positioned(
                top: 8,
                left: 12,
                child: widget.activityModel.activityStatus == 1
                    ? Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: hexStringToOpacityColor('#1C1E21', 0.6),
                            borderRadius: BorderRadius.circular(5)),
                        child: Constants.regularWhiteTextWidget(
                            widget
                                .activityModel.timeAirBattleHomeDifferentString,
                            14),
                      )
                    : Container(
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image: AssetImage('images/airbattle/trophy.png'),
                              width: 12,
                              height: 10,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Constants.regularWhiteTextWidget(
                                widget.activityModel.statuString, 14,
                                height: 1.0),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: hexStringToOpacityColor('#1C1E21', 0.6),
                            borderRadius: BorderRadius.circular(5)),
                      )),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TTNetImage(
                    url: widget.activityModel.activityIcon,
                    placeHolderPath: 'images/airbattle/icon.png',
                    height: 32,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Constants.boldWhiteTextWidget(
                      widget.activityModel.activityTitle, 20),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: Constants.screenWidth(context) - 112,
                    child: Constants.regularWhiteTextWidget(
                        'Test your limits, improve your game,and claim your spot on the leaderboard for a chance to win amazing prizes!',
                        14,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      print('点击活动规则入口');
                      // 配置活动规则的H5页面的话直接跳转webview 没有的话 直接跳转到本地的页面
                      if(!ISEmpty(widget.activityModel.activityH5)){
                        NavigatorUtil.push(Routes.webview,arguments: widget.activityModel.activityH5);
                       // NavigatorUtil.present(TTWebViewController(webUrl: widget.activityModel.activityH5,));
                      }else{
                        NavigatorUtil.present(AirBattleRulerController(
                          startDate: widget.activityModel.startDate,
                          endDate: widget.activityModel.endDate,
                          monthString: widget.activityModel.monthString,
                          totalDays: widget.activityModel.totalDays,
                        ));
                      }
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Constants.customTextWidget('Learn More', 12, '#F8850B'),
                        SizedBox(width: 4,),
                        Image(image: AssetImage('images/airbattle/green.png'),height: 8,fit: BoxFit.fitHeight,)
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 56,
              right: 56,
              child: GestureDetector(
                onTap: () async {},
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(239, 137, 20, 1.0),
                        Color.fromRGBO(207, 57, 26, 1.0)
                      ],
                    ),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Constants.boldWhiteTextWidget('Join Now', 16),
                        ),
                        Positioned(
                            top: 6,
                            right: 6,
                            child: Image(
                              image: AssetImage('images/participants/next.png'),
                              width: 31,
                              height: 31,
                            ))
                      ],
                    ),
                    onTap: () {
                      NavigatorUtil.push('activityDetail',
                          arguments: widget.activityModel);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }
}
