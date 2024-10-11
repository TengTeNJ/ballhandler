import 'package:code/constants/constants.dart';
import 'package:code/models/game/game_over_model.dart';
import 'package:code/services/http/rank.dart';
import 'package:code/utils/color.dart';
import 'package:code/widgets/base/base_image.dart';
import 'package:flutter/material.dart';

import '../../models/global/user_info.dart';
import '../../route/route.dart';
import '../../utils/dialog.dart';
import '../../utils/navigator_util.dart';

class RankingItemView extends StatefulWidget {
  RankModel model;

  RankingItemView({required this.model});

  @override
  State<RankingItemView> createState() => _RankingItemViewState();
}

class _RankingItemViewState extends State<RankingItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.model.trainVideo.isEmpty ||
            !widget.model.trainVideo.contains('http')) {
          return;
        }
        if (UserProvider.of(context).subscribeModel.subscribeStatus != 1) {
          // 未订阅 则限制进入
         // NavigatorUtil.push(Route)
          NavigatorUtil.push(Routes.subscribeintroduce);
          //TTDialog.subscribeDialog(context);
          return;
        }
        GameOverModel model = GameOverModel();
        model.rank = widget.model.rankNumber.toString();
        model.videoPath = widget.model.trainVideo.toString();
        model.avgPace = widget.model.avgPace.toString();
        model.score = widget.model.trainScore;
        model.endTime = widget.model.createTime;
        model.modeId = widget.model.modeId;
        model.sceneId = widget.model.sceneId;
        print('model.path=${model.videoPath}');
        NavigatorUtil.push('videoPlay',
            arguments: {"model": model, "gameFinish": false});
      },
      child: Container(
        decoration: BoxDecoration(
            color: hexStringToColor('#3E3E55'),
            borderRadius: BorderRadius.circular(10)),
        height: 72,
        child: Stack(
          children: [
            (widget.model.trainVideo.length > 0 &&
                    widget.model.trainVideo.contains('http'))
                ? Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                        width: 32,
                        height: 14,
                        decoration: BoxDecoration(
                            color: Constants.baseStyleColor,
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                            child:
                                Constants.regularWhiteTextWidget('View', 10))))
                : Container(),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Constants.boldWhiteTextWidget(
                          widget.model.rankNumber.toString(), 20),
                      SizedBox(
                        width: 16,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: ISEmpty(widget.model.avatar)
                            ? Container(
                                width: 38,
                                height: 38,
                                color: hexStringToColor('#AA9155'),
                              )
                            : TTNetImage(
                                url: widget.model.avatar.toString(),
                                placeHolderPath: '',
                                width: 38,
                                height: 38,
                              ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: Constants.screenWidth(context) - 280),
                        child: Constants.mediumWhiteTextWidget(
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            widget.model.nickName.toString(),
                            20),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Constants.regularGreyTextWidget(
                          widget.model.country.toString(), 10),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text('0.9',style: TextStyle(fontSize: 20,height: 1.0,color: Colors.white),),
                      Constants.boldWhiteTextWidget(
                          widget.model.avgPace.toString(), 20,
                          height: 0.8),
                      SizedBox(
                        width: 8,
                      ),
                      Constants.regularWhiteTextWidget('sec/pt', 10)
                    ],
                  ),
                ],
              ),
              left: 24,
              right: 24,
              top: 16,
              bottom: 16,
            ),
          ],
        ),
      ),
    );
  }
}
