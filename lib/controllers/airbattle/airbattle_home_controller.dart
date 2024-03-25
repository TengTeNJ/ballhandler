import 'package:code/models/airbattle/activity_model.dart';
import 'package:code/views/activity_view/activity_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class AirBattleHomeController extends StatefulWidget {
  const AirBattleHomeController({super.key});

  @override
  State<AirBattleHomeController> createState() =>
      _AirBattleHomeControllerState();
}

class _AirBattleHomeControllerState extends State<AirBattleHomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Constants.darkThemeColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.boldWhiteTextWidget('Air Battle', 30),
                Container(
                  width: 20,
                  height: 24,
                  child: Stack(
                    children: [
                      Image(image: AssetImage('images/airbattle/message.png')),
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4)),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.darkControllerColor),
                  width: (Constants.screenWidth(context) - 40) * 0.357,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Constants.mediumWhiteTextWidget('Activity', 14),
                            Image(
                                width: 18,
                                height: 18,
                                image: AssetImage('images/airbattle/next.png'))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        margin: EdgeInsets.only(left: 16, right: 16),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Constants.mediumWhiteTextWidget('10', 40),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Constants.regularGreyTextWidget('Attended', 14),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.darkControllerColor),
                  width: (Constants.screenWidth(context) - 40) * 0.643,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Constants.mediumWhiteTextWidget('Activity', 14),
                            Image(
                                width: 18,
                                height: 18,
                                image: AssetImage('images/airbattle/next.png'))
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        margin: EdgeInsets.only(left: 16, right: 16),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Constants.mediumWhiteTextWidget('10', 40),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Constants.regularGreyTextWidget('Award', 14),
                            Container(
                              height: 26,
                              width: 120,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Constants.regularGreyTextWidget(
                                          'Points', 14),
                                      Row(
                                        children: [
                                          Constants.regularBaseTextWidget(
                                              '200', 14),
                                          Constants.regularWhiteTextWidget(
                                              '/1000', 14),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(10),
                                    value: 0.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Constants.baseStyleColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Constants.mediumWhiteTextWidget('All Activity', 16),),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16,right: 16),
            child: ActivityListView(datas: [ActivityModel(),ActivityModel()],),
          )),
        ],
      ),
    );
  }
}
