import 'dart:async';

import 'package:code/controllers/airbattle/airbattle_ruler_controller.dart';
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
                url: widget.activityModel.activityBackground,
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
                right: 12,
                top: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('点击活动规则入口');
                    NavigatorUtil.present(AirBattleRulerController(startDate: widget.activityModel.startDate,endDate: widget.activityModel.endDate,));
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                        color: hexStringToOpacityColor('#1C1E21', 0.6),
                        borderRadius: BorderRadius.circular(13)),
                    child: Center(
                      child: Image(
                        image: AssetImage('images/airbattle/question.png'),
                        height: 13,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
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
                    width: 58,
                    height: 58,
                    borderRadius: BorderRadius.circular(29),
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
                        widget.activityModel.activityRemark, 14,
                        height: 1.2),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 36,
              right: 36,
              child: GestureDetector(
                onTap: () async {},
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(182, 246, 29, 1.0),
                        Color.fromRGBO(219, 219, 20, 1.0)
                      ],
                    ),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Constants.boldBlackTextWidget(
                            widget.activityModel.activityButtonTitle, 16,
                            height: 1.2),
                        SizedBox(
                          width: 6,
                        ),
                        Image(
                          image: AssetImage('images/airbattle/black_next.png'),
                          width: 10,
                          height: 10,
                        )
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
