import 'package:code/utils/nsuserdefault_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../constants/constants.dart';
import '../../route/route.dart';
import '../../services/http/airbattle.dart';
import '../../utils/color.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class AirBattleGuideController extends StatelessWidget {
  ActivityModel? model;
  ActivityDetailModel? detailModel ;
  AirBattleGuideController({super.key, this.model, this.detailModel});

  @override
  Widget build(BuildContext context) {
    if(detailModel != null){
      // 从详情页进来此页面 只弹一次
      NSUserDefault.setKeyValue(detailModel!.activityId.toString(), 'true');
    }
    return Scaffold(
      backgroundColor: Constants.darkControllerColor,
      body: Container(
        decoration: BoxDecoration(
          color: Constants.darkControllerColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                left: 16,
                top: 16,
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
                        image: AssetImage('images/participants/back_grey.png'),
                        width: 16,
                        height: 12,
                      ),
                    ),
                  ),
                )),
            Positioned(
                top: 52,
                bottom: 130,
                left: 16,
                right: 16,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                        SizedBox(height: 8,),
                      Constants.mediumWhiteTextWidget('How to Join the Battle \nand Ensure a Valid Video', 20,height: 1.5),
                      SizedBox(height: 32,),
                      Constants.boldWhiteTextWidget('01.', 30),
                      SizedBox(height: 8,),
                      Constants.boldBaseTextWidget('Camera Preview', 16),
                      SizedBox(height: 8,),
                      Constants.regularGreyTextWidget('Once you click "Join" from the active battle,\nthe video recording camera preview will open.', 16,height: 1.5),
                      SizedBox(height: 32,),

                      Constants.boldWhiteTextWidget('02.', 30),
                      SizedBox(height: 8,),
                      Constants.boldBaseTextWidget('Adjust Camera', 16),
                      SizedBox(height: 8,),
                      Constants.regularGreyTextWidget('Use the in-app preview screen to adjust the\ncamera until your full rangeof motion is visible\n(Digital Stickhandling Trainer in "ZigZag" shape,\nhands, stick, and body).', 16,height: 1.5),
                      SizedBox(height: 32,),

                      Constants.boldWhiteTextWidget('03.', 30),
                      SizedBox(height: 8,),
                      Constants.boldBaseTextWidget('Check Lighting', 16),
                      SizedBox(height: 8,),
                      Constants.regularGreyTextWidget('Ensure your area is well-lit,\navoiding any bright backlighting that could\nobscure your video.', 16,height: 1.5),
                      SizedBox(height: 32,),

                      Constants.boldWhiteTextWidget('04.', 30),
                      SizedBox(height: 8,),
                      Constants.boldBaseTextWidget('Start the Battle', 16),
                      SizedBox(height: 8,),
                      Constants.regularGreyTextWidget('Once you\'re ready and the camera is set,\nclick "Start" in the app tobegin*,\nand start the play from the Digital Stickhandling\nTrainer. The battle will begin and\nrecording will start.', 16,height: 1.5),
                      SizedBox(height: 49,),
                    Constants.customTextWidget('*Note: Always “Start” from APP to ensure the video recording is triggered for and linked to the battle.', 16, '#B6F61D',height: 1.5)
                    ],
                  ),
                )),
            Positioned(
                left: 24,
                right: 24,
                bottom: 54,
                child: GestureDetector(
                  onTap: (){
                    if(detailModel != null && model != null){
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      gameUtil.isFromAirBattle = true;
                      gameUtil.activityModel = model!;
                      gameUtil.modelId = int.parse(detailModel!.modeId);
                      gameUtil.gameScene = [
                        GameScene.five,
                        GameScene.erqiling,
                        GameScene.threee
                      ][int.parse(detailModel!.sceneId) - 1];
                      NavigatorUtil.popAndThenPush(Routes.recordselect);
                    }else{
                      NavigatorUtil.pop();
                    }

                  },
                  child: Container(
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
                      child: Constants.boldWhiteTextWidget('Continue', 16),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
