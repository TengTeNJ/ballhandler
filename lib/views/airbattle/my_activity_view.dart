import 'package:code/constants/constants.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/base_image.dart';
import 'package:flutter/material.dart';

import '../../models/game/game_over_model.dart';
import '../../models/global/user_info.dart';
import '../../route/route.dart';
import '../../utils/dialog.dart';
import '../../utils/navigator_util.dart';
class MyActivityDataView extends StatefulWidget {
  MyActivityModel  activityModel;
  MyActivityDataView({required this.activityModel});

  @override
  State<MyActivityDataView> createState() => _MyActivityDataViewState();
}

class _MyActivityDataViewState extends State<MyActivityDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: Constants.screenWidth(context) - 32,
      decoration: BoxDecoration(
        color: hexStringToColor('#3E3E55'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Visibility(
              visible: widget.activityModel.trainVideo.contains('http'),
              replacement: Container(),
              child: Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      if(UserProvider.of(context).subscribeModel.subscribeStatus != 1){
                        // 未订阅 则限制进入
                        NavigatorUtil.push(Routes.subscribeintroduce);
                        //TTDialog.subscribeDialog(context);
                        return;
                      }
                      GameOverModel model = GameOverModel();
                      model.rank = widget.activityModel.rankNumber.toString();
                      model.videoPath = widget.activityModel.trainVideo.toString();
                      model.avgPace = widget.activityModel.avgPace.toString();
                      model.score = widget.activityModel.trainScore;
                      model.endTime = widget.activityModel.createTime;
                      print('model.path=${model.videoPath}');
                      NavigatorUtil.push('videoPlay',
                          arguments: {"model": model, "gameFinish": false});
                    },
                    child: Container(
                      width: 34,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Constants.baseStyleColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Constants.regularWhiteTextWidget('VIEW', 10),
                      ),
                    ),
                  ))),
          Positioned(
              top: 12,
              bottom: 12,
              left: 16,
              right: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TTNetImage(url: widget.activityModel.activityIcon, placeHolderPath: 'images/airbattle/airbattle_little.png', width: 48, height: 48,borderRadius: BorderRadius.circular(24),),
                  SizedBox(width: 16,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Constants.customTextWidget(widget.activityModel.activityName, 14, '#B1B1B1'),
                          SizedBox(width: 16,),
                          Constants.regularWhiteTextWidget(widget.activityModel.startDate, 10),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.rankNumber, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Rank', 12, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.trainScore, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Score', 12, '#B1B1B1'),
                            ],
                          ),
                          Column(
                            children: [
                              Constants.mediumWhiteTextWidget(widget.activityModel.avgPace, 20),
                              SizedBox(height: 4,),
                              Constants.customTextWidget('Sec/Pts', 12, '#B1B1B1'),
                            ],
                          )
                        ],
                      )
                    ],
                  ))
                ],
              )),
        ],
      ),
    );
  }
}
