import 'package:code/constants/constants.dart';
import 'package:code/utils/color.dart';
import 'package:code/views/airbattle/airbattle_data_view.dart';
import 'package:code/views/airbattle/airbattle_detail_grid_view.dart';
import 'package:flutter/material.dart';

class ActivityDetailController extends StatefulWidget {
  const ActivityDetailController({super.key});

  @override
  State<ActivityDetailController> createState() =>
      _ActivityDetailControllerState();
}

class _ActivityDetailControllerState extends State<ActivityDetailController> {
  bool _end = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.darkThemeColor,
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 270,
            color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                    top: Constants.appBarHeight + 16,
                    left: 16,
                    child: Image(
                      width: 36,
                      height: 36,
                      image: AssetImage('images/base/back.png'),
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Constants.boldWhiteTextWidget('How Many In 45s', 30,
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
                    'Digital stickhandling trainer', 12),
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
                    childAspectRatio: 0.5, // 设置宽高低，否则宽度默认和撑起的高度一样
                    crossAxisCount: 2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 64),
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return AirBattleGridView(
                      imagePath: 'images/airbattle/time.png',
                      title: 'Time',
                      detail: '00:55');
                }),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Constants.mediumWhiteTextWidget('Champion', 16),
          ),
          Container(
            margin: EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: AirBattleDataView(
                grade: Grade.gold,
                userName: 'Jay',
                area: 'China',
                birthday: 'JULY 2024 10:10',
                rank: 1,
                score: 100,
                avgPace: 0.5),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Constants.mediumWhiteTextWidget('Completed', 16),
          ),
          Container(
            margin: EdgeInsets.only(left: 16,right: 16,bottom: 16),
            child: AirBattleDataView(
                grade: Grade.gold,
                userName: 'Jay',
                area: 'China',
                birthday: 'JULY 2024 10:10',
                rank: 1,
                score: 100,
                avgPace: 0.5),
          ),
          SizedBox(height: 60,),
          _end == true ? _endButtonView() : Container(
            margin: EdgeInsets.only(left: 16,right: 16,bottom: 32),
            height: 56,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                hexStringToColor('#EF8914'),
                hexStringToColor('#E53F1D'),
              ],
            ),),
            child: Center(child: Constants.boldWhiteTextWidget('Starting in 74:30:10', 16),),
          )
        ],
      ),),
    );
  }
}

Widget _endButtonView(){
  return Container(
    margin: EdgeInsets.only(left: 16,right: 16,bottom: 32),
    height: 56,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        hexStringToColor('#B5B5B5'),
        hexStringToColor('#717171'),
      ],
    ),),
    child: Center(child: Constants.boldWhiteTextWidget('End', 16),),
  );
}
