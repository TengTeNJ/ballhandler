import 'dart:async';

import 'package:code/route/route.dart';
import 'package:code/services/http/airbattle.dart';import 'package:code/utils/navigator_util.dart';
import 'package:code/views/airbattle/activity_list_view.dart';
import 'package:code/widgets/navigation/CustomAppBar.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../services/http/profile.dart';
import '../../utils/notification_bloc.dart';
import '../profile/integral_controller.dart';

class AirBattleHomeController extends StatefulWidget {
  const AirBattleHomeController({super.key});

  @override
  State<AirBattleHomeController> createState() =>
      _AirBattleHomeControllerState();
}

class _AirBattleHomeControllerState extends State<AirBattleHomeController> {
  AirBattleHomeModel _model = AirBattleHomeModel();
  late StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAirBattleData();
    // 监听
    subscription = EventBus().stream.listen((event) {
      if ( event == kFinishGame || event == kMessageRead || event == kGetMessage) {
        // 完成游戏
        queryAirBattleData();
      }
    });
  }

  queryAirBattleData() async{
    final _response = await AirBattle.queryIAirBattleData();
    if(_response.success && _response.data != null){
      _model = _response.data!;
      if(mounted){
        setState(() {

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Constants.baseControllerColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Constants.darkThemeColor, Constants.baseControllerColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
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
                        ( _model.unreadCount != null && _model.unreadCount > 0) ? Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4)),
                            )) :Container()
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
                GestureDetector(onTap: (){
                  NavigatorUtil.push('myActivity');
                },child: Container(
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
                            _model.activityCount.toString(), 40), ),
                    ],
                  ),
                ),),
                SizedBox(width: 8,),
                GestureDetector(
                  onTap: (){
                    NavigatorUtil.push(Routes.awardlist); // 跳转到获奖列表页面
                  },
                  child: Container(
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
                              _model.activityAward.toString(), 40), ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async{
                    final _response = await Profile.queryIMyAccountInfoData();
                    if(_response.success && _response.data != null){
                      MyAccountDataModel _model = _response.data!;
                      NavigatorUtil.present(IntegralController(model: _model,));
                    }

                  },
                  child: Container(
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
                              _model.activityIntegral.toString(), 40), ),
                      ],
                    ),
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
                    NavigatorUtil.push('activityDetail',arguments: model);
                  }
                ),
              )),
        ],
      ),
    );
  }
}
