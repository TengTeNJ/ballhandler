import 'dart:async';

import 'package:code/utils/notification_bloc.dart';
import 'package:code/utils/string_util.dart';
import 'package:code/views/airbattle/airbattle_info_card_view.dart';
import 'package:code/views/airbattle/airbattle_list_view.dart';
import 'package:code/views/airbattle/airbattle_page_view.dart';
import 'package:code/views/airbattle/airbattle_tab_buttons.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/airbattle/my_airbattle_pucks_model.dart';
import '../../services/http/airbattle.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/navigation/CustomAppBar.dart';

class AirbattleController extends StatefulWidget {
  const AirbattleController({super.key});

  @override
  State<AirbattleController> createState() => _AirbattleControllerState();
}

class _AirbattleControllerState extends State<AirbattleController> {
  AirBattleHomeModel _model = AirBattleHomeModel();
  MyAirBattlePucksModel _pucksModel = MyAirBattlePucksModel();
  int _activityId = 0;
  List<String> _tabDess = ['Top scores, top players. Can you beat them?','Most improved. Progress is the real win!','Stay active, stay in the game. Keep battling!'];
  int _tabIndex = 0;
  DateTime _startDate = DateTime.now();
  late StreamSubscription subscription;
  // 查询参与的活动列表数据 比如消息未读的数量
  queryAirBattleData() async {
    final _response = await AirBattle.queryAirBattleData();
    if (_response.success && _response.data != null) {
      _model = _response.data!;
      if (mounted) {
        setState(() {});
      }
    }
  }

  /*查询AirBattle我的积分页面数据*/
  queryAirBattleMyPucksData() async {
    final _response = await AirBattle.queryAirBattleMyPucksData(_activityId);
    if (_response.success && _response.data != null) {
      _pucksModel = _response.data!;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) {
    if(event is String && event == kBackFromFinish){
      print('----++++');
        // 游戏完成返回后重新刷新积分等数据
      queryAirBattleMyPucksData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Constants.baseControllerColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Constants.darkThemeColor,
                    Constants.baseControllerColor
                  ],
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
                              image:
                                  AssetImage('images/airbattle/message.png')),
                          (_model.unreadCount != null && _model.unreadCount > 0)
                              ? Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4)),
                                  ))
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              // color: Colors.red,
              width: Constants.screenWidth(context) - 16,
              height: (Constants.screenWidth(context) - 32) * (246 / 340),
              child: AirbattlePageView(
                scrollToPage: (int activityId,String startDate) {
                  // 活动切换 包含首次
                  setState(() {
                    _startDate = StringUtil.stringToDate(startDate);
                    _tabIndex = 0;
                    _activityId = activityId;
                    // 通知tabbuttons进入默认选中首个状态
                    EventBus().sendEvent(kAirBattleChangeActivity);
                    // 查询AirBattle我的积分页面的数据
                    queryAirBattleMyPucksData();
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AirbattleInfoCardView(
                    startDayIndex: _startDate.day,
                      monthDay: _startDate.month,
                      title: 'Awards',
                      value:  _model.activityAward,
                      imageName: 'info2',
                      des: ' More'),
                  AirbattleInfoCardView(
                    startDayIndex: _startDate.day,
                    monthDay: _startDate.month,
                    title: 'My Journey',
                    value: int.parse(_pucksModel.trainIntegral),
                    imageName: 'info1',
                    des: 'Pucks',
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(239, 137, 20, 1.0),
                        Color.fromRGBO(207, 57, 26, 1.0)
                      ],
                    ),
                    pucksModel: _pucksModel,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Constants.mediumWhiteTextWidget('Leaderbroad', 16),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            AirbattleTabButtons(
              titles: [
                'Battle Champions',
                'Rising Stars',
                'Consistent Contenders'
              ],
              selectTab: (index) {
                print('select ${[
                  'Battle Champions',
                  'Rising Stars',
                  'Consistent Contenders'
                ][index]}');
                setState(() {
                  _tabIndex = index;
                });
                int _index = index;
                // 最多次数和最大进步顺序调整了
                if (_index == 1) {
                  _index = 2;
                } else if (_index == 2) {
                  _index = 1;
                }
                EventBus().sendEvent('${kAirBattleTabSelect}${_index + 1}');
              },
            ),
            SizedBox(
              height: 24,
            ),
            Constants.regularGreyTextWidget(
                _tabDess[_tabIndex], 14),
            SizedBox(
              height: 16,
            ),
            Container(
              width: Constants.screenWidth(context) - 32,
              child: AirbattleListView(
                activityId: _activityId,
                key: ValueKey(_activityId),
              ),
            ),
            SizedBox(
              height: 26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
    super.dispose();
  }
}
