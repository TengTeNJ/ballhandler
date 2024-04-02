import 'package:code/models/airbattle/activity_model.dart';
import 'package:code/utils/navigator_util.dart';
import 'package:code/views/airbattle/activity_list_view.dart';
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
                GestureDetector(
                  onTap: () {
                    NavigatorUtil.push('message');
                  },
                  child: Container(
                    width: 20,
                    height: 24,
                    child: Stack(
                      children: [
                        Image(
                            image: AssetImage('images/airbattle/message.png')),
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
                ),
              ],
            ),
          ),
          SizedBox(
            height: 19,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.darkControllerColor),
                  width: (Constants.screenWidth(context) - 48) / 3,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                          child: Constants.regularGreyTextWidget(
                              'Activity', 12), ),
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                        child: Constants.mediumWhiteTextWidget(
                            '10', 40), ),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.darkControllerColor),
                  width: (Constants.screenWidth(context) - 48) / 3,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                        child: Constants.regularGreyTextWidget(
                            'My Rewards', 12), ),
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                        child: Constants.mediumWhiteTextWidget(
                            '1', 40), ),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.darkControllerColor),
                  width: (Constants.screenWidth(context) - 48) / 3,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                        child: Constants.regularGreyTextWidget(
                            'Activity Points', 12), ),
                      Padding(padding: EdgeInsets.only(left: 12, top: 12),
                        child: Constants.mediumWhiteTextWidget(
                            '20', 40), ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8,),
          SizedBox(
            height: 32,
          ),
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Constants.mediumWhiteTextWidget('All Activity', 16),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: ActivityListView(
                  selectItem: (ActivityModel model) {
                    print('点击了活动');
                    NavigatorUtil.push('activityDetail');
                  },
                  datas: [ActivityModel(), ActivityModel()],
                ),
              )),
        ],
      ),
    );
  }
}
