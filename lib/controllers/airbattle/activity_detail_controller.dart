import 'package:camera/camera.dart';
import 'package:code/constants/constants.dart';
import 'package:code/models/global/user_info.dart';
import 'package:code/route/route.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/dialog.dart';
import 'package:code/utils/string_util.dart';
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
   // String timeArea = StringUtil.stringToDate(widget.model.startDate)
    _details = ['00:45 sec', widget.model.startDate  + '-' + widget.model.endDate,  UserProvider.of(context).group, '200\$'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 270,
              child: Stack(
                children: [
                  TTNetImage(
                      url: widget.model.activityBackground,
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
                  widget.model.activityName, 30,
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
                      widget.model.activityRemark, 12),
                )),
            Padding(
              padding: EdgeInsets.all(16),
              // 自动换行撑起高度的话 不要设置maxLines
              // child: Text('ctivity rules Activity rulesActivity rulesActivity rulesActivity Activity rulesActivity rulesActivity rules',style: TextStyle(color: Colors.red),),
              child: Constants.regularGreyTextWidget(
                  'Activity rules Activity rulesActivity rulesActivity rulesActivity Activity rulesActivity rulesActivity rules',
                  14,
                  textAlign: TextAlign.left),
            ),
            Container(
              margin: EdgeInsets.all(16),
              height: 144,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
           widget.model.activityStatus == 2 ? Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
             Container(
               margin: EdgeInsets.all(16),
               child: Constants.mediumWhiteTextWidget('Champion', 16),
             ),
             Container(
               margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
               child: AirBattleDataView(
                   grade: Grade.gold,
                   userName: 'Jay',
                   area: 'China',
                   birthday: 'JULY 2024 10:10',
                   rank: 1,
                   score: 100,
                   avgPace: 0.5),
             ),
           ],) :Container(), // 冠军
            widget.model.activityStatus !=0 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  child: Constants.mediumWhiteTextWidget('Completed', 16),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: AirBattleDataView(
                      grade: Grade.gold,
                      userName: 'Jay',
                      area: 'China',
                      birthday: 'JULY 2024 10:10',
                      rank: 1,
                      score: 100,
                      avgPace: 0.5),
                ),
              ],
            ) :Container(), // 已完成的最高成绩
            SizedBox(
              height: 60,
            ),
            widget.model.activityStatus != 1
                ? _endButtonView(widget.model)
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      // List<CameraDescription> cameras =
                      //     await availableCameras();
                      TTDialog.joinAirBattle(context, (){
                        GameUtil gameUtil = GetIt.instance<GameUtil>();
                        gameUtil.isFromAirBattle = true;
                        gameUtil.activityModel = widget.model;
                        NavigatorUtil.push(Routes.recordselect);
                      },(){
                        NavigatorUtil.push(Routes.setting);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
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
                            'Starting in 74:30:10', 16),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

Widget _endButtonView( ActivityModel model) {
  if(model.activityStatus == 0){
    // 未开始
  }else{
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
