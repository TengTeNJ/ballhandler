import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/airbattle.dart';
import 'package:code/utils/color.dart';
import 'package:code/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/global/user_info.dart';
import '../../route/route.dart';
import '../../utils/dialog.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class TodayDataView extends StatefulWidget {
  GameOverModel gameOverModel;
  TodayDataView({required this.gameOverModel});

  @override
  State<TodayDataView> createState() => _TodayDataViewState();
}

class _TodayDataViewState extends State<TodayDataView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _scene = widget.gameOverModel.sceneId;
    String _modelId = widget.gameOverModel.modeId;
    String _title =
        kGameSceneAndModelMap[_scene]![_modelId] ?? 'ZIGZAG Challenge';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.gameOverModel.videoPath.isEmpty ||
            !widget.gameOverModel.videoPath.contains('http')) {
          return;
        }
        if (UserProvider.of(context).subscribeModel.subscribeStatus != 1) {
          // 未订阅 则限制进入
          NavigatorUtil.push(Routes.subscribeintroduce);
         // TTDialog.subscribeDialog(context);
          return;
        }
        NavigatorUtil.push('videoPlay',
            arguments: {"model": widget.gameOverModel, "gameFinish": false});
      },
      child: Container(
        height: 86,
        width: Constants.screenWidth(context) - 32,
        decoration: BoxDecoration(
          color: hexStringToColor('#3E3E55'),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            (widget.gameOverModel.videoPath.length > 0 &&
                    widget.gameOverModel.videoPath.contains('http'))
                ? Positioned(
                    top: 8,
                    right: 8,
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
                    ))
                : Container(),
            Positioned(
                top: 12,
                bottom: 12,
                left: 16,
                right: 46,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(
                        image:
                            AssetImage('images/participants/icon_orange.png'),
                        width: 48,
                        height: 48,
                        fit: BoxFit.fill),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 110),
                              child: Constants.customTextWidget(
                                  _title, 14, '#B1B1B1',
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            Constants.regularWhiteTextWidget(
                                StringUtil.serviceStringToShowMinuteString(
                                    widget.gameOverModel.endTime),
                                10),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Constants.mediumWhiteTextWidget(
                                    widget.gameOverModel.avgPace, 20),
                                SizedBox(
                                  height: 4,
                                ),
                                Constants.customTextWidget(
                                    'Sec/Pts', 10, '#B1B1B1'),
                              ],
                            ),
                            Column(
                              children: [
                                Constants.mediumWhiteTextWidget(
                                    widget.gameOverModel.score, 20),
                                SizedBox(
                                  height: 4,
                                ),
                                Constants.customTextWidget(
                                    'Pts', 10, '#B1B1B1'),
                              ],
                            ),
                            Column(
                              children: [
                                Constants.mediumWhiteTextWidget(
                                    StringUtil.timeStringFormat(
                                        widget.gameOverModel.trainTime),
                                    20),
                                SizedBox(
                                  height: 4,
                                ),
                                Constants.customTextWidget(
                                    'Sec', 10, '#B1B1B1'),
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
      ),
    );
  }
}
