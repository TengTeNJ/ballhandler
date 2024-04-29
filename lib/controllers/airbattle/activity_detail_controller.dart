import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/views/airbattle/airbattle_data_view.dart';
import 'package:code/views/airbattle/airbattle_detail_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../services/http/airbattle.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../widgets/base/base_image.dart';

class ActivityDetailController extends StatefulWidget {
  ActivityModel model;

  ActivityDetailController({required this.model});

  @override
  State<ActivityDetailController> createState() =>
      _ActivityDetailControllerState();
}

class _ActivityDetailControllerState extends State<ActivityDetailController> {
  ActivityDetailModel detailModel = ActivityDetailModel();
  final List<String> _iconPaths = [
    'images/airbattle/time.png',
    'images/airbattle/date.png',
    'images/airbattle/player.png',
    'images/airbattle/award.png'
  ];
  final List<String> _titles = ['TIME', 'Date', 'Player', 'Award'];
  List<String> _details = ['', '', '', ''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _details = [
      '00:45 sec',
      widget.model.startDate + '-' + widget.model.endDate,
      UserProvider.of(context).group,
      '${widget.model.rewardMoney}\$'
    ];
    queryActivityDetailData();
  }

  queryActivityDetailData() async {
    final _response =
        await AirBattle.queryIActivityDetailData(widget.model.activityId);
    if (_response.success && _response.data != null) {
      detailModel = _response.data!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 270,
                      child: Stack(
                        children: [
                          TTNetImage(
                              url: detailModel.activityBackground,
                              placeHolderPath: 'images/airbattle/under_way.png',
                              width: Constants.screenWidth(context),
                              height: 270),
                          Positioned(
                              left: 16,
                              top: 60,
                              child: GestureDetector(
                                onTap: () {
                                  NavigatorUtil.pop();
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: hexStringToColor('#65657D')),
                                  child: Center(
                                    child: Image(
                                      image: AssetImage(
                                          'images/participants/back_grey.png'),
                                      width: 16,
                                      height: 12,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Constants.boldWhiteTextWidget(
                          detailModel.activityName, 30,
                          textAlign: TextAlign.left),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 16),
                        decoration: BoxDecoration(
                            color: hexStringToColor('#3E3E55'),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Constants.regularBaseTextWidget(
                              detailModel.activityRemark, 12),
                        )),
                    Padding(
                      padding: EdgeInsets.all(16),
                      // 自动换行撑起高度的话 不要设置maxLines
                      // child: Text('ctivity rules Activity rulesActivity rulesActivity rulesActivity Activity rulesActivity rulesActivity rules',style: TextStyle(color: Colors.red),),
                      child: Constants.regularGreyTextWidget(
                          detailModel.activityRule, 14,
                          textAlign: TextAlign.left),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      height: 144,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.4, // 设置宽高比，否则宽度默认和撑起的高度一样
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 32,
                                  mainAxisSpacing: 64),
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return AirBattleGridView(
                                imagePath: _iconPaths[index],
                                title: _titles[index],
                                detail: _details[index]);
                          }),
                    ),
                    detailModel.activityStatus == 2
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(16),
                                child: Constants.mediumWhiteTextWidget(
                                    'Champion', 16),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16),
                                child: AirBattleDataView(
                                    grade: Grade.gold,
                                    userName:
                                        detailModel.champion.championNickName,
                                    area: detailModel.champion.championCountry,
                                    birthday: 'JULY 2024 10:10',
                                    rank: '1',
                                    score: detailModel
                                        .champion.championTrainScore,
                                    avgPace:
                                        detailModel.champion.championAvgPace),
                              ),
                            ],
                          )
                        : Container(), // 冠军
                    (detailModel.activityStatus != 0 &&
                            detailModel.self.nickName != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(16),
                                child: Constants.mediumWhiteTextWidget(
                                    'Completed', 16),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16),
                                child: AirBattleDataView(
                                    grade: Grade.gold,
                                    userName:
                                        detailModel.self.nickName ?? 'Guest',
                                    area: detailModel.self.country ?? '',
                                    birthday: 'JULY 2024 10:10',
                                    rank: detailModel.self.rankNumber ?? '-',
                                    score: detailModel.self.trainScore ?? '-',
                                    avgPace: detailModel.self.avgPace),
                              ),
                            ],
                          )
                        : Container(), // 已完成的最高成绩
                    SizedBox(
                      height: 60,
                    ),

                    detailModel.activityStatus == 2
                        ? _endButtonView(detailModel)
                        : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        if( detailModel.isJoin == 0){
                          // 未加入则先加入游戏
                          TTDialog.joinAirBattle(context, () async{
                            final _response = await  AirBattle.joinActivity(widget.model.activityId);
                            if(_response.success){
                              detailModel.isJoin = 1;
                              setState(() {

                              });
                              GameUtil gameUtil = GetIt.instance<GameUtil>();
                              gameUtil.isFromAirBattle = true;
                              gameUtil.activityModel = widget.model;
                              gameUtil.modelId = int.parse(detailModel.modeId);
                              gameUtil.gameScene = [GameScene.five,GameScene.threee,GameScene.erqiling][int.parse(detailModel.sceneId) - 1];
                              NavigatorUtil.push(Routes.recordselect);
                            }

                          }, () {
                            NavigatorUtil.push(Routes.setting);
                          });
                        }else{
                          // 已经报名过 直接跳转到确认页面
                          GameUtil gameUtil = GetIt.instance<GameUtil>();
                          gameUtil.isFromAirBattle = true;
                          gameUtil.activityModel = widget.model;
                          gameUtil.modelId = int.parse(detailModel.modeId);
                          gameUtil.gameScene = [GameScene.five,GameScene.threee,GameScene.erqiling][int.parse(detailModel.sceneId) - 1];
                          NavigatorUtil.push(Routes.recordselect);
                        }

                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, bottom: 32),
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              hexStringToColor('#EF8914'),
                              hexStringToColor('#E53F1D'),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Constants.boldWhiteTextWidget(
                                 detailModel.isJoin == 0 ? 'JOIN' :  'End in ${detailModel.timeDifferentString}',
                              16),
                        ),
                      ),
                    )
                  
                  ],
                ),
              )),

        ],
      ),
    );
  }
}
/*活动已结束End*/
Widget _endButtonView(ActivityDetailModel model) {
  if (model.activityStatus == 0) {
    // 未开始
  } else {
    // 已结束
  }
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
    height: 56,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          hexStringToColor('#B5B5B5'),
          hexStringToColor('#717171'),
        ],
      ),
    ),
    child: Center(
      child: Constants.boldWhiteTextWidget('End', 16),
    ),
  );
}
